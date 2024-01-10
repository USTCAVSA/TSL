"""
The telingo module contains functions to translate and solve temporal logic
programs.

Classes:
Application -- Main application class.

Functions:
imain -- Function to run the incremetal solving loop.
main  -- Main function starting an extended clingo application.
"""

from telingo import transformers as _tf
from telingo import theory as _ty

import sys as _sys
import os
import clingo as _clingo
import clingo.ast as _ast
from clingo.application import Application as _Application
import textwrap as _textwrap

def imain(prg, future_sigs, program_parts, on_model, imin = 0, imax = None, istop = "SAT"):
    """
    Take a program object and runs the incremental main solving loop.

    For each pair (name, arity) in future_sigs all atoms in the program base
    with the time parameter referring to the future are set to false. For
    example, given (p, 2) and atoms  p(x,1) in step 0, the atom would p(x,1)
    would be set to false via an assumption. In the following time steps, it
    would not be set to False.

    The list program_parts contains all program parts appearing in the program
    in form of triples (root, name, range) where root is either "initial" (time
    step 0), "always" (time steps >= 0), or "dynamic" (time steps > 0) and
    range is a list of integers for which the part has to be grounded
    backwards. Given range [0, 1] and root "always", at each iteration the
    program part would be grounded at horizon and horizon-1. The latter only if
    the horizon is greater than 0.

    Arguments:
    prg           -- Control object holding the program.
    future_sigs   -- Signatures of predicates whose future incarnations have to
                     be set to False.
    program_parts -- Program parts to ground.
    imin          -- Minimum number of iterations.
    imax          -- Maximum number of iterations.
    istop         -- When to stop.
    """
    f = _ty.Theory()
    step, ret = 0, None
    while ((imax is None or step < imax) and
           (step == 0 or step < imin or (
              (istop == "SAT"     and not ret.satisfiable) or
              (istop == "UNSAT"   and not ret.unsatisfiable) or
              (istop == "UNKNOWN" and not ret.unknown)))):
        parts = []
        for root_name, part_name, rng in program_parts:
            for i in rng:
                if ((step - i >= 0 and root_name == "always") or
                    (step - i  > 0 and root_name == "dynamic") or
                    (step - i == 0 and root_name == "initial")):
                    parts.append((part_name, [_clingo.Number(step - i), _clingo.Number(step)]))
        if step > 0:
            prg.release_external(_clingo.Function("__final", [_clingo.Number(step-1)]))
            prg.cleanup()
        prg.ground(parts)
        f.translate(step, prg)
        prg.assign_external(_clingo.Function("__final", [_clingo.Number(step)]), True)
        assumptions = []
        for name, arity, positive in future_sigs:
            for atom in prg.symbolic_atoms.by_signature(name, arity, positive):
                if atom.symbol.arguments[-1].number > step:
                    assumptions.append(-atom.literal)
        ret, step = prg.solve(on_model=lambda m: on_model(m, step), assumptions=assumptions), step+1
    return ret

class Application(_Application):
    """
    Application object as accepted by clingo.clingo_main().

    Rewrites the incoming temporal logic programs into incremental ASP programs
    and solves them.
    """
    def __init__(self, rules=[], imin=0, imax=None, istop="SAT"):
        """
        Initializes the application setting the program name.

        See clingo.clingo_main().
        """
        self.program_name = "telingo"
        self.version = "2.1.1"

        self.__imin = imin
        self.__imax = imax
        self.__istop = istop
        self.horizon = 0
        self.__rules = rules
        self.models = []
        self.ret = None
        self.step = None

    def __on_model(self, model, horizon):
        """
        Prints the atoms in a model grouped by state.

        Arguments:
        model -- The model to print.
        horizon -- The number of states.
        """
        self.horizon = horizon
        self.models.append(self.parse_model(model))
    
    def parse_model(self, model):
        table = {}
        answer_set = []
        for sym in model.symbols(shown=True):
            if sym.type == _clingo.SymbolType.Function and len(sym.arguments) > 0:
                table.setdefault(sym.arguments[-1].number, []).append(_clingo.Function(sym.name, sym.arguments[:-1], sym.positive))
        for step in range(self.horizon+1):
            state = []
            symbols = table.get(step, [])
            for sym in sorted(symbols):
                if not sym.name.startswith('__'):
                    state.append(sym)
            answer_set.append(state)
        return answer_set

    
    def print_model(self, model, printer):
        table = {}
        for sym in model.symbols(shown=True):
            if sym.type == _clingo.SymbolType.Function and len(sym.arguments) > 0:
                table.setdefault(sym.arguments[-1].number, []).append(_clingo.Function(sym.name, sym.arguments[:-1], sym.positive))
        for step in range(self.horizon+1):
            symbols = table.get(step, [])
            _sys.stdout.write(" State {}:".format(step))
            sig = None
            for sym in sorted(symbols):
                if not sym.name.startswith('__'):
                    if (sym.name, len(sym.arguments), sym.positive) != sig:
                        _sys.stdout.write("\n ")
                        sig = (sym.name, len(sym.arguments), sym.positive)
                    _sys.stdout.write(" {}".format(sym))
            _sys.stdout.write("\n")
        return True

    def main(self, prg, files):
        """
        Implements the incremental solving loop.

        This function implements the Application.main() function as required by
        clingo.clingo_main().
        """
        with _ast.ProgramBuilder(prg) as b:
            # files = [open(f) for f in files]
            # if len(files) == 0:
            #     files.append(_sys.stdin)
            future_sigs, program_parts = _tf.transform(self.__rules, b.add)

        self.ret = imain(prg, future_sigs, program_parts, self.__on_model, self.__imin, self.__imax, self.__istop)

def solve(map, vehilces, imin=0, imax=None, istop="SAT", horizon=True):
    """
    Run the telingo application.
    """
    rule = open(os.path.join(os.path.dirname(__file__), 'asp/rules.lp')).read()
    show = open(os.path.join(os.path.dirname(__file__), 'asp/show.lp')).read()
    rules = [rule, map, vehilces, show]
    if horizon:
        rules.append(open(os.path.join(os.path.dirname(__file__), 'asp/horizon.lp')).read())
    app = Application(rules, imin, imax, istop)
    _clingo.clingo_main(app, ["0","-q2","-Wnone","--outf=3"])
    return app.models, app.ret, app.horizon

if __name__ == "__main__":
    map = open(os.path.join(os.path.dirname(__file__), 'asp/map.lp')).read()
    vehilces = open(os.path.join(os.path.dirname(__file__), 'asp/vehicles.lp')).read()
    solve(map, vehilces)

# TSL
Traffic Scenario Logic: A Spatial-Temporal Logic for Modeling and Reasoning of Urban Traffic Scenarios

使用时态逻辑建模的城市交通场景逻辑

## How to use

1. You need to install [Telingo](https://github.com/potassco/telingo) to run TSL.
2. Enter the `asp/` folder.
3. Add a map file `map.lp` and the vehicles' initial configuration `car.lp`.
4. Run Telingo to solve it:
    ```
    telingo N map.lp car.lp rules.lp show.lp
    ```
    where `N` is the number of answer sets you want (0 for all). You can refer to Telingo's document for more usage of other parameters.

The conversion from OpenDRIVE to TSL representation is a part of our [DADSim Project](https://github.com/DAD-Sim).

## Examples

See `examples/`.

## Citation
```
@misc{wang2024traffic,
      title={Traffic Scenario Logic: A Spatial-Temporal Logic for Modeling and Reasoning of Urban Traffic Scenarios}, 
      author={Ruolin Wang and Yuejiao Xu and Jianmin Ji},
      year={2024},
      eprint={2405.13715},
      archivePrefix={arXiv},
      primaryClass={cs.LO}
}
```

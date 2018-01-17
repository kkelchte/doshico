# Experiments to be conducted at the side

### Influence of training in different order: canyon -> forest -> sandbox vs canyon -> canyon+forest -> sandbox+canyon+forest


### Relationship between Canyon-Forest-Sandbox and corresponding Almost-Collision data

| Model trained on | Perspective lines | Vertical lines | Strange shapes |
|------------------|--------------------------|-----------------------|-----------------------|
| Canyon           |        42.2  +/-   0.5   |       31.5  +/-  1.4  |      59.7  +/-   0.8  |
| Sandbox          |        31.4  +/-   4.1   |       27.9  +/-  1.6  |      24.7  +/-   2.0  |
| Forest           |        23.5  +/-   3.0   |       30.9  +/-  2.7  |      19.9  +/-   1.5  |

Models trained offline on the canyon dataset performs best. Although on the perspective and vertical lines the canyon models perform almost as good as random (depending on your random distribution). The reason for better performance is probably due to the only extreme labels (-1 or 1) in the canyon dataset. Therefore the model will not predict often between -0.3 and +0.3 of which is also almost no data is available in the almost-collision dataset.

The sandbox has a relatively better peformance on the perspective lines probably thanks to perspective lines coming from the walls in the data. The forest does relatively better than the sandbox on the vertical lines, though this is not as different from the sandbox-models.

The canyon models demonstrate less variance over the real world dataset than the models trained on Sandbox or Forest.

The online evaluation in ESAT:

| for : 11runs | avg dist | success rate |
|-|-|-|
| doshico_auxd_for/doshico_11 | 3 | 0/20 |
| doshico_auxd_for/doshico_14 | 26 | 0/20 |
| doshico_auxd_for/doshico_17 | 3 | 0/11 |
| doshico_auxd_for/doshico_18 | 12 | 0/20 |
| doshico_auxd_for/doshico_19 | 9 | 0/20 |
| doshico_auxd_for/doshico_2 | 1 | 0/26 |
| doshico_auxd_for/doshico_3 | 9 | 0/20 |
| doshico_auxd_for/doshico_5 | 4 | 0/20 |
| doshico_auxd_for/doshico_7 | 2 | 0/20 |
| doshico_auxd_for/doshico_8 | 5 | 0/5 |
| doshico_auxd_for/doshico_9 | 2 | 0/20 |

| san : 16runs | avg dist | success rate |
|-|-|-|
| doshico_auxd_san/doshico_0 | 2 | 0/20 |
| doshico_auxd_san/doshico_1 | 3 | 0/20 |
| doshico_auxd_san/doshico_10 | 4 | 0/20 |
| doshico_auxd_san/doshico_11 | 2 | 0/12 |
| doshico_auxd_san/doshico_12 | 3 | 0/4 |
| doshico_auxd_san/doshico_13 | 2 | 0/14 |
| doshico_auxd_san/doshico_14 | 4 | 0/20 |
| doshico_auxd_san/doshico_15 | 5 | 0/18 |
| doshico_auxd_san/doshico_16 | 5 | 0/20 |
| doshico_auxd_san/doshico_17 | 4 | 0/9 |
| doshico_auxd_san/doshico_18 | 2 | 0/10 |
| doshico_auxd_san/doshico_19 | 3 | 0/21 |
| doshico_auxd_san/doshico_3 | 5 | 0/13 |
| doshico_auxd_san/doshico_4 | 2 | 0/16 |
| doshico_auxd_san/doshico_6 | 2 | 0/6 |
| doshico_auxd_san/doshico_9 | 6 | 0/17 |

| can : 11runs | avg dist | success rate |
|-|-|-|
| doshico_auxd_can/doshico_0 | 1 | 0/20 |
| doshico_auxd_can/doshico_10 | 1 | 0/20 |
| doshico_auxd_can/doshico_11 | 1 | 0/1 |
| doshico_auxd_can/doshico_13 | 1 | 0/20 |
| doshico_auxd_can/doshico_14 | 1 | 0/34 |
| doshico_auxd_can/doshico_15 | 2 | 0/20 |
| doshico_auxd_can/doshico_16 | 2 | 0/12 |
| doshico_auxd_can/doshico_18 | 2 | 0/7 |
| doshico_auxd_can/doshico_19 | 1 | 0/21 |
| doshico_auxd_can/doshico_2 | 1 | 0/20 |
| doshico_auxd_can/doshico_9 | 2 | 0/20 |

Surprisingly it is the forest data that seems to provide to most usefull information for the model to fly online through ESAT>




---
subtitle: K. Kelchtermans
title: Try it yourself!
layout: post
permalink: try
---

Everything required to reproduce the results is made **accessible**. In the following steps we explain first how to obtain access to the three big software packages (ROS, Gazebo and Tensorflow) with the use of docker. Second, we go over the installation of small packages locally from within a docker container. The final step entails the usage of the code in order to reproduce our results as well as get new results of your own.

If you use the code in your own work, please refer correctly to [our paper]({{ "/assets/paper.pdf" | absolute_url }} "Open PDF view").

{% highlight tex %}
	@article{ kelchter2017doshico,
		title={DoShiCo: Domain Shift challenge for Control},
		author={Kelchtermans, Klaas and Tuytelaars, Tinne},
		year={2017}}
{% endhighlight %}



<h2><a href="https://github.com/kkelchte/doshico/tree/master/assets/code" target="_blank">1. Build a Docker Image</a></h2>
DoShiCo requires a combination of [ROS (kinetic)](http://wiki.ros.org/kinetic/Installation "wiki.ros.org"), [Gazebo (7)](http://gazebosim.org/tutorials?tut=install_ubuntu&ver=7.0 "gazebosim.org") and [Tensorflow-gpu (1.11)](https://www.tensorflow.org/ "tesorflow.org") with [nvidia](https://developer.nvidia.com/cuda-downloads "cuda-download") (CUDA >=8.0). Installing ROS is most convenient on a Ubuntu (16.4) operating system. The full installation can be tedious. Therefore we supply a docker image with all four requirements that can easily be pulled from the [dockerhub page](https://hub.docker.com/ "hub.docker.com"). Before you can do this, you'll have to have [docker](https://docs.docker.com/engine/installation/ 'docs.docker.com/engine/installation') installed and running. We also assume you have an nvidia GPU available with drivers installed as well as [nvidia-docker](https://github.com/NVIDIA/nvidia-docker "github/nvidia-docker"). We also provide a [troubleshoot page](trouble/#prerequisites "troubleshoot") with more instructions on the installation of the prerequisits.

Once the prerequisites (docker, nvidia and nvidia-docker) are fullfilled, you can use a local version of the image with the following scripts. Please read the script files before running as some environment variables might be system dependent.

>1. Copy the following [scripts](https://github.com/kkelchte/doshico/tree/master/assets/code "docker-scripts"){:target="_blank"} in a local directory.
1. Run the script the `build.sh` script in order to create a doshico_image.
1. (Optional) Use the `run.sh`, `save.sh` and `test.sh 0` to play around with the image and container if you're not used to docker. In case you encounter a problem, you might find the solution [here](troubleshoot.md "Troubleshoot page"). If not, feel free to contact me.


Note: The docker image has Xpra installed. This makes it possible to run applications without using a graphical session. The latter is especially suited in combination with a computing cluster where graphical sessions are often not allowed. Instructions on running the image with xpra is left out of this page for readibility.




<h2>2. Install ROS- and Tensorflow-packages</h2>
If all big software packages (ROS, Gazebo, Tensorflow) are installed or accessible in a docker image, it is now time to clone the local ROS- and Tensorflow-packages for flying the drone with a DNN policy. As we want you to easily adjust the packages, we did not include the code in the docker image. The structure of the packages are depicted bellow. The arrows indicate dependencies.

* <a href="https://github.com/kkelchte/hector_quadrotor" target="_blank">Drone Simulator</a> is a simulated version of the bebop 2 drone based on the Hector quadrotor package.
* <a href="https://github.com/kkelchte/simulation_supervised" target="_blank">Simulated-Supervised</a> is a ROS package forming the interface between the simulated drone and the DNN policy.
* <a href="https://github.com/kkelchte/pilot" target="_blank">Pilot</a> represents the code block for training the DNN policy in an online or offline fashion with tensorflow. 
* Log folder with checkpoints:
	* imagenet-pretrained [mobilenet 0.25](https://homes.esat.kuleuven.be/~kkelchte/checkpoints/mobilenet_025.zip){: target="_blank"}
	* doshico-pretrained [NAUX](https://homes.esat.kuleuven.be/~kkelchte/checkpoints/naux.zip){: target="_blank"}
	* doshico-pretrained [AUXD](https://homes.esat.kuleuven.be/~kkelchte/checkpoints/auxd.zip){: target="_blank"}
* The data consists of 3 sets:
	* <a href="https://homes.esat.kuleuven.be/~kkelchte/data/pilot_data/canyon_forest_sandbox.zip" target="_blank">Canyon_forest_sandbox</a> with data collected by the expert in the training environments (canyon, forest, sandbox).
	* <a href="https://homes.esat.kuleuven.be/~kkelchte/data/pilot_data/esat.zip" target="_blank">ESAT</a> with data collected by the expert in the validation environment (ESAT).
	* <a href="https://homes.esat.kuleuven.be/~kkelchte/data/pilot_data/almost_collision_set.zip" target="_blank">The Almost-Collision dataset</a> with data collected by hand in the real world of almost collisions imposing only one correct action.

![frontpage]({{ "/assets/img/project.png" | absolute_url }}){: .center-image}

The installation of the packages is explained with two scripts:

> * <a href="https://github.com/kkelchte/doshico/tree/master/assets/instructions/step_one.sh" target="_blank">Step 1</a>: Installing and testing the **offline** setting.
* <a href="https://github.com/kkelchte/pilot/blob/master/scripts/step_two.sh" target="_blank">Step 2</a>: Installing and testing the **online** setting. 


<h2>3. The Challenge</h2>
The DoShiCo challenge focusses on dealing with the domain shift when training a policy in basic environments and see if it adapts to more realistic and real-world environments. The goal is to perform monocular collision avoidance with a UAV over 1 direction.

![variance]({{ "/assets/img/frontpage.png" | absolute_url }}){: .center-image }

The policy has to be based solely in monocular RGB input. The **training** happens in three types of basic simulated environments: Canyon, Forest and Sandbox. The environments are generated on the fly at random. The training procedure is left open: online/offline, reinforcement or imitation learning, ... . 

Validate the policy **online** in a more realistic ESAT corridor. The performance is measured in average flying distance in the 2 directions of the corridor while flying at a constant speed of 0.8m/s.

Test the policy **offline** on the Almost-Collision dataset. Comparing performances in the real-world is hard due to many external factors (battery state, wind turbulences,...). The Almost-Collision dataset contains small trajectories capturing very near collisions that can only be avoided with the correct action. The performance should be measured as accuracies. The continuous control in  yaw  is  discretized  with thresholds ±0.3 for left, straight and right.

The large variance that comes along with training deep neural network policies makes it hard to compare different methods. We strongly recommend to include a graph similar to the image below. It depicts the performance over the percentage of policies reaching this performance.

![variance]({{ "/assets/img/variance.png" | absolute_url }}){: .center-image }


| Flying Distance <br/>(m) | NAUX   | AUXD  |
|:-------------|:-------:|:------:|
| Canyon       | 43.96  | 38.41 |
| Forest       | 45.99  | 50.24 |
| Sandbox      | 7.03   | 8.62  |
| ESAT         | 47.03  | 57.63 |

Our results, as demonstrated in [our paper]({{ "/assets/paper.pdf" | absolute_url }} "PDF view"), can be used as a benchmark. The values present the average over the top 10% policies trained from 50 trained policies. You can use the test scripts within the [pilot](https://github.com/kkelchte/pilot) package to reproduce these numbers or improve on them.

| Almost-Collision <br/> Accuracies | AUXD |
|------------:|:--------:|
| ESAT real | 64 |
| Corridor 1 | 67 |
| Corridor 2 | 35 |
| Office  |52 |
| Cafeteria | 25 |
| Garage | 61 |
| Night | 63 |
| Avg. Loc. | 52 |


If you have any questions regarding the code or installation, feel free to contact me. Goodluck!


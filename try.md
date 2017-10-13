---
subtitle: K. Kelchtermans
title: Try it yourself!
layout: post
permalink: try
---

We made everything required to reproduce the results accessible. In the following steps we explain first the installation of the three big software packages: ROS, Gazebo and Tensorflow. Second we go over the installation of small packages. The final step entails the usage of the code in order to reproduce our results as well as get new results of your own.

If you use the code in your own work, please refer correctly to [our paper]({{ "/assets/paper.pdf" | absolute_url }} "Open PDF view").

{% highlight tex %}
	@article{ kelchter2017doshico,
		title={DoShiCo: Domain Shift challenge for Control},
		author={Kelchtermans, Klaas and Tuytelaars, Tinne},
		year={2017}}
{% endhighlight %}

<h2>1. Get Docker image</h2>
DoShiCo requires a combination of [ROS (kinetic)](http://wiki.ros.org/kinetic/Installation "wiki.ros.org"), [Gazebo (7)](http://gazebosim.org/tutorials?tut=install_ubuntu&ver=7.0 "gazebosim.org") and [Tensorflow-gpu (1.11)](https://www.tensorflow.org/ "tesorflow.org") with [nvidia](https://developer.nvidia.com/cuda-downloads "cuda-download") (CUDA >=8.0). Installing ROS is most convenient on a Ubuntu (16.4) operating system. The full installation can be tedious. Therefore we supply a docker image with all 4 requirements that can easily be pulled from the [dockerhub page](https://hub.docker.com/ "hub.docker.com"). Before you can do this, you'll have to have docker [installed](https://docs.docker.com/engine/installation/ 'docs.docker.com/engine/installation') and running. It might take some time but it is certainly worth it. We also assume you have an nvidia GPU available with drivers installed as well as [nvidia-docker](https://github.com/NVIDIA/nvidia-docker "github/nvidia-docker"). [Here](trouble/#prerequisites "troubleshoot") you can find more information about installing the prerequisites.

Once the prerequisites (docker, nvidia and nvidia-docker) are fullfilled, you can use a local version of the image with the following scripts. Please read the script files before running them as some environment variables might be system dependent.

1. Copy [these files](https://github.com/kkelchte/doshico/tree/master/assets/code "code"){:target="_blank"} in a local directory.
1. Run the scripts in the following order:
	1. `build.sh` builds from the docker file a docker image named doshico_image. Note that as the image contains three large software packages, its size is around 12G and will probably take a while to be pulled from the docker hub.
	1. `run.sh` starts the doshico_image in a container, running an interactive bash shell.
	1. `save.sh` commits changes in your container back to the doshico_image. Save the changes while your container is running as the container will be deleted (--rm) when it is not running anymore.
	1. `test.sh 0` tests different parts of the docker container starting from 0 up to 6. In case you encounter a problem, you might find the solution [here](troubleshoot.md "Troubleshoot page"). If not, feel free to contact me.


> Note: The docker image has Xpra installed. This makes it possible to run applications without using a graphical session. The latter is especially suited in combination with a computing cluster where graphical sessions are often not allowed. Instructions on running the image with xpra is left out of this page for readibility.




<h2>2. Install ROS- and Tensorflow-packages</h2>
If all big software packages (ROS, Gazebo, Tensorflow) are installed or accessible in a docker image, it is now time to clone the local ROS- and Tensorflow-packages for flying the drone with a DNN policy. As we want you to easily adjust the packages, we did not include the code in the docker image. The structure of the packages are depicted bellow. The arrows indicate dependencies.

* <a href="https://github.com/kkelchte/hector_quadrotor" target="_blank">Drone Simulator</a> is a simulated version of the bebop 2 drone based on the Hector quadrotor package of TU Darmstad.
* <a href="https://github.com/kkelchte/simulation-supervised" target="_blank">Simulated-Supervised</a> is a ROS package forming the interface between the simulated drone and the DNN policy
* <a href="https://github.com/kkelchte/pilot_online" target="_blank">Online Training</a> represents the code block for training the DNN policy in an online fashion with tensorflow. The checkpoints are used and kept in a log folder.
* <a href="https://github.com/kkelchte/pilot_offline" target="_blank">Offline Training</a> represents the code block for training the DNN policy offline from offline data.
* <a href="https://homes.esat.kuleuven.be/~kkelchte/checkpoints/models.zip" target="_blank">Log</a> is a folder containing the latest checkpoints and is used during offline and online training.
* The data contains of 3 sets:
	* <a href="https://homes.esat.kuleuven.be/~kkelchte/data/pilot_data/canyon_forest_sandbox.zip" target="_blank">Canyon_forest_sandbox</a> with data collected by the expert in the training environments (canyon, forest, sandbox).
	* <a href="https://homes.esat.kuleuven.be/~kkelchte/data/pilot_data/esat.zip" target="_blank">ESAT</a> with data collected by the expert in the validation environment (ESAT).
	* <a href="https://homes.esat.kuleuven.be/~kkelchte/data/pilot_data/almost_collision_set.zip" target="_blank">The Almost-Collision dataset</a> with data collected by hand in the real world of almost collisions imposing only one correct action.


![frontpage]({{ "/assets/img/project.png" | absolute_url }}){: .center-image }


<h2>3. The Challenge</h2>
The DoShiCo challenge focusses on dealing with the domain shift when training a policy in basic environments and see if it adapts to more realistic or even realistic environments. The policy is one of basic 1d collision-avoidance.

![variance]({{ "/assets/img/frontpage.png" | absolute_url }}){: .center-image }

The policy has to be based solely in monocular RGB input. The **training** happens in three types of basic simulated environments: Canyon, Forest and Sandbox. The environments are generated on the fly at random. The training procedure is left open: online/offline, reinforcement or imitation learning, ... . 

Validate/Test the policy **online** in a more realistic ESAT corridor. The performance is measured in average flying distance in the 2 directions of the corridor while flying at a constant speed of 0.8m/s.

Validate/Test the policy **offline** on the Almost-Collision dataset. Comparing performances in the real-world is hard due to many external factors (battery state, wind turbulences,...). The Almost-Collision dataset contains small trajectories capturing very near collisions that can only be avoided with the correct action. The performance should be measured as accuracies. The continuous control in  yaw  is  discretized  with thresholds ±0.3 for left, straight and right.

The large variance that comes along with training deep neural network policies makes it hard to compare different methods. We strongly recommend to include a graph similar to the image bellow. It depicts the performance over the percentage of policies reaching this performance.

![variance]({{ "/assets/img/variance.png" | absolute_url }}){: .center-image }

Goodluck!


<!-- 
<h4>Drivers</h4>
<h2>3. Reproduce Results</h2>

In order to reproduce the results there is a big package of ROS required called DoShiCo? / simulation-supervised. This package groups the DoShiCo environments in simulation-supervised-demo, the behavior arbitration control for supervision in a control subpackage and extra tools. The main simulation-supervised package contains scripts required to run the training over different training methods....
<h3>Install DoShi</h3>

<h3>DoShiCo environments</h3>
Demo package of simulation-supervised

<h3>Simulation-Supervision</h3>
Behavior arbitration package and how to use it

<h3>Simulation-Supervision</h3>

![frontpage]({{ "/assets/img/frontpage.png" | absolute_url }}){: .center-image }
 -->
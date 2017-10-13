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

Once the prerequisites (docker, nvidia and nvidia-docker) are fullfilled, you can build a local version of the image with the following steps:
1. copy [these files](https://github.com/kkelchte/kkelchte.github.io/doshico/assets/code "code") in a local directory
1. run the scripts in the following order:
	1. `./build.sh` : builds from the docker file a docker image named doshico_image. Note that as the image contains three large software packages, its size is around 12G and will probably take a while to be pulled from the docker hub.
	1. `./run.sh` : starts the doshico_image in a container, running an interactive bash shell.
	1. `./save.sh`: commits changes in your container back to the doshico_image. Save the changes while your container is running as the container will be deleted (--rm) when it is not running anymore.
	1. `./test.sh 0`: test different parts of the docker container starting from 0 up to 6.

Please read the script files before running them as some environment variables might be system dependent.
  



> Note: The docker image has Xpra installed. This makes it possible to run applications without using a graphical session. The latter is especially suited in combination with a computing cluster where graphical sessions are often not allowed. In order to start the Xpra, you'll have to adjust the entrypoint in order to set the correct environment variables.




<h2>2. Install ROS- and Tensorflow-packages</h2>
If all big software packages (ROS, Gazebo, Tensorflow) are installed or accessible in a docker image, it is now time to clone the local ROS- and Tensorflow-packages for flying the drone with a DNN policy. As we want yourself to easily adjust the packages we did not include the code in the docker image. The structure of the packages are depicted bellow. The arrows indicate dependencies.

* <a href="https://github.com/kkelchte/hector_quadrotor" target="_blank">Drone Simulator</a> is a simulated version of the bebop 2 drone based on the Hector quadrotor package of TU Darmstad.
* <a href="https://github.com/kkelchte/simulated-supervised" target="_blank">Simulated-Supervised</a> is a ROS package forming the interface between the simulated drone and the DNN policy
* <a href="https://github.com/kkelchte/pilot_online" target="_blank">Online Training</a> represents the code block for training the DNN policy in an online fashion with tensorflow. The checkpoints are used and kept in a log folder.
* <a href="https://github.com/kkelchte/pilot_offline" target="_blank">Offline Training</a> represents the code block for training the DNN policy offline from offline data.
* <a href="https://homes.esat.kuleuven.be/~kkelchte/checkpoints/offl_mobsm_test.zip" target="_blank">Log</a> is a folder containing the latest checkpoints and is used during offline and online training.
* <a href="https://homes.esat.kuleuven.be/~kkelchte/pilot_data/data.zip" target="_blank">Data</a> is a folder containing data captured by the expert in the DoShiCo environments and used for offline training.


![frontpage]({{ "/assets/img/project.png" | absolute_url }}){: .center-image }

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
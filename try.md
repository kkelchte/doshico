---
subtitle: K. Kelchtermans
title: Try it yourself!
layout: post
permalink: try
---

We made everything required to reproduce the results accessible. In the following steps we explain first the installation of the three big software packages: ROS, Gazebo and Tensorflow. Second we go over the installation of small packages. The final step entail the usage of the code in order to reproduce our results as well as get new results of your own.

If you use the code in your own work, please refer correctly to [our paper]({{ "/assets/paper.pdf" | absolute_url }} "Open PDF view").

{% highlight tex %}
	@article{ kelchter2017doshico,
		title={DoShiCo: Domain Shift challenge for Control},
		author={Kelchtermans, Klaas and Tuytelaars, Tinne},
		year={2017}}
{% endhighlight %}

<h2>1. Get Docker image</h2>
DoShiCo requires a combination of [ROS (kinetic)](http://wiki.ros.org/kinetic/Installation "wiki.ros.org"), [Gazebo (7)](http://gazebosim.org/tutorials?tut=install_ubuntu&ver=7.0 "gazebosim.org") and [Tensorflow-gpu (1.11)](https://www.tensorflow.org/ "tesorflow.org") for [nvidia](https://developer.nvidia.com/cuda-downloads "cuda-download") (CUDA >=8.0). Installing ROS is most convenient on a Ubuntu (16.4) operating system. The full installation can be tedious. Therefore we supply a docker image with all 4 requirements that can easily be pulled from the [dockerhub page](https://hub.docker.com/ "hub.docker.com"). Before you can do this, you'll have to have docker installed. For this you can find instructions [here](https://docs.docker.com/engine/installation/ 'docs.docker.com/engine/installation'). It might take a while but it is worth getting familiar with. We also assume a nvidia GPU is available with drivers installed as well as nvidia-docker. More information about installing the prerequisites can be found [here](trouble/#prerequisites "troubleshoot").

Once the prerequisites are fullfilled, you can build a local version of the image with the following steps:
* copy files from here in a local directory
* 

Note that as it contains three large software packages, its size is around 12G and will probably take a while to be pulled.  

{% highlight bash %}
$ docker pull kkelchte/ros_gazebo_tensorflow
{% endhighlight%}

Running the docker image with your home folder mounted and the local graphical session forwarded should not be more than a few lines:
{% highlight bash %}
# nvidia-docker ensures that the nvidia drivers is mounted with the correct version
# -e option sets the correct environment variable
# -v option mounts a directory locally to a directory in the docker container
# --name your container so that you can commit it later to an image for reuse
# add -it for interactive session
# bash demands a running bash shell
$ sudo docker run \
	--name container_name \
	-it \
	kkelchte/ros_gazebo_tensorflow \
	bash
root@somenumbers:/# id
	uid=0(root) gid=0(root) groups=0(root)
{% endhighlight %}

You should now be able to enter the image as a root (uid=0). This will prevent write access to your home folder as it has a different user identity. It is therefore best to add yourself as a user in current container.
{% highlight bash %}
# in a different window check your normal user id
$ echo $UID
1234
# if your user id is not 1000, you'll have to add it in the docker container with the following command
root@somenumbers:/# adduser --uid YOURID YOURNAME
# see if you can enter in the running container from another terminal window as the other user
$ sudo docker exec \
		-it \
		-u YOURID \
		-v $HOME:/home/guest\
		-e HOME=/home/guest\
		container_name bash
YOURNAME@somenumbers:/$ cd
YOURNAME@somenumbers:~$ pwd
/home/guest
YOURNAME@somenumbers:~$ touch test
# if your user ID was added correctly you can now update the container to a local image 
# with the 'docker commit' command in a new local terminal
$ sudo docker commit container_name YOUR_DOCKER_REPOSITORY
{% endhighlight %}

Congratulations! You have created a local copy of my docker image with your user ID added. Now you can adjust you own mounted home folder from within the image.

It is time to make some checks to see if everything went well.
{% highlight bash %}
# start your container from your updated image
# --rm deletes the container after logging out
# -v mounts your home directory to /home/YOURNAME
# -v /tmp/.X11-unix mounts the X server allowing software within use it
# -e sets the DISPLAY environments variable
# it is important to run a container from the image from your repository as you have a user account in it.
$ sudo docker run \
	-it \
	--rm \
	-u YOURID \
	-v $HOME:/home/YOURNAME \
	-e $HOME=/home/YOURNAME \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-e DISPLAY=$DISPLAY \
	YOUR_DOCKER_REPOSITORY bash
# $$ indicates the bash line within the container
# source ros setup:
$$ source "/opt/ros/$ROS_DISTRO/setup.bash"
# start ros and a gui to see if it displays correctle:
$$ roscore &
...
$$ rosrun rqt_gui rqt_gui
# If everything went correctly you should see the rqt graphical user interface running on ROS
{% endhighlight %}

Preferrably your computer has a Nvidia GPU with nvidia drivers and the CUDA toolkit(>8.0) installed. This is required for Tensorflow-gpu. If not, a local [Tensorflow](https://www.tensorflow.org/install/install_linux#InstallingVirtualenv) version can be installed for instance in a virtual environment in your mounted home folder. 

In case you have a Nvidia-GPU the <a href="https://github.com/NVIDIA/nvidia-docker" target="_blank">Nvidia-docker plugin (1.0.1)</a> should be installed. Check the installation in this way:

{% highlight bash %}
$ sudo nvidia-docker run \
		-it \
		-u YOURID \
		-v $HOME:/home/guest\
		-e HOME=/home/guest\
		container_name bash
[inside container]$ ls /dev
...nvidia0...
#There
{% endhighlight %}

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
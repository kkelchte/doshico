---
subtitle: K. Kelchtermans
title: Trouble Shooting
layout: post
permalink: trouble
---

Starting to work with docker can be a bit more challenging as one might expect. We added this page to cover the most probable issues step by step. 

# Installing Prerequisites

In order to run the docker image the following packages are required: [**docker (CE)**](https://www.docker.com/get-docker "get-docker"), [**nvidia-drivers**](https://developer.nvidia.com/cuda-downloads) and [**nvidia-docker**](https://github.com/NVIDIA/nvidia-docker).

[**docker (CE)**](https://www.docker.com/get-docker "get-docker") should be accessible on linux, windows and mac but in for this troubleshoot it is only tested on linux. If you are new to docker, I would recommend going through the first set of [tutorials](https://docs.docker.com/get-started). The installation is very straightforward. If everything went well you should be able to run:
```bash
$ docker run hello-world
Hello ...
$ docker --version
``` 

For getting [**nvidia-drivers**](https://developer.nvidia.com/cuda-downloads), it is recommended to install the drivers from a package manager like apt or dnf. You might want to install the CUDA toolkit and Cudnn libraries, though this is not required as they are already included in the docker image. Good instructions for installing nvidia on ubuntu can be found [here](https://gist.github.com/wangruohui/df039f0dc434d6486f5d4d098aa52d07 "Install NVIDIA Driver and CUDA"). Note that you'll have to reinstall your drivers at each kernel update. As a sidenote it is recommended to keep the driver run file after installation as it can often be used to uninstall the drivers correctly.
If everything went well you should be able to run:
```bash
$ nvidia-smi
```

[**Nvidia-docker**](https://github.com/NVIDIA/nvidia-docker) ensures that when a docker container is run that uses the nvidia GPU, the drivers are mounted on the correct place. It is a daemon that after installation and rebooting should run in the background publishing the required information on [your localhost](http://localhost:3476/docker/cli) where it provides the necessary flags. These flags are added to the run command when you use `nvidia-docker` instead of `docker`. Test it out with:
```bash
$ nvidia-docker run --rm nvidia/cuda nvidia-smi
```

Please validate if they are all three installed correctly before diving deeper.


# Troubleshoot

## Running gzserver within docker image
In order to make this work you need:
* nvidia driver installed and mounted by nvidia-docker
* export LD_LIBRARY_PATH=/usr/local/nvidia/lib64
* add a display when running the container as user 1000
```bash
$ gzserver --verbose
...[Msg] Waiting for master.
[Msg] Connected to gazebo master @ http://127.0.0.1:11345
[Msg] Publicized address: 172.17.0.2
libGL error: No matching fbConfigs or visuals found
libGL error: failed to load driver: swrast
X Error of failed request:  BadValue (integer parameter out of range for operation)
  Major opcode of failed request:  154 (GLX)
  Minor opcode of failed request:  3 (X_GLXCreateContext)
  Value in failed request:  0x0
  Serial number of failed request:  30
  Current serial number in output stream:  31
$ export LD_LIBRARY_PATH=/usr/local/nvidia/lib64
$ gzserver --verbose
...[Msg] Connected to gazebo master @ http://127.0.0.1:11345
[Msg] Publicized address: 172.17.0.2
```

<!-- OLD TEXT NOT USED
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
{% endhighlight %} -->



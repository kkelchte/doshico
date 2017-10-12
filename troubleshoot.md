---
subtitle: K. Kelchtermans
title: Trouble Shooting
layout: post
permalink: trouble
---

Starting to work with docker can be a bit more challenging as one might expect. We added this page to cover the most probable issues step by step. 

## Prerequisites

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

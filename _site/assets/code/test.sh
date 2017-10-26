#!/bin/bash
clear

# adjust the variable bellow if you set your docker_home somewhere else
HOME=/$HOME/docker_home

# Go over each test by running this script in different terminal windows
# adjusting TEST from 0 to ...
TEST=0
if [ -n $1 ] ; then
	echo "TEST: $1"
	TEST=$1
fi

# ----------------------------------------------
# TEST 0
# Start a container with top to see which processes started 
if [ $TEST = 0 ] ; then
	sudo nvidia-docker run -it \
		--rm \
		-v $HOME:/home/$USER \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		--name doshico_container \
		doshico_image top
fi

# ----------------------------------------------
# TEST 1
# Start ROS in the container in one screen:
if [ $TEST = 1 ] ; then
	COMMAND="/bin/bash /ros_entrypoint.sh roscore"
	echo $COMMAND
	sudo nvidia-docker exec \
		-it \
		doshico_container $COMMAND
fi

# ----------------------------------------------
# TEST 2
# Start a ROS gui 
if [ $TEST = 2 ] ; then
	COMMAND="/bin/bash /ros_entrypoint.sh rosrun rqt_gui rqt_gui"
	echo $COMMAND
	sudo nvidia-docker exec \
		-it \
		doshico_container $COMMAND
fi

# ----------------------------------------------
# TEST 3
# Start gzserver: the headless version of gazebo
# keep it running as we will connect to the client in the next step.
if [ $TEST = 3 ] ; then
	COMMAND="/bin/bash /ros_entrypoint.sh gzserver --verbose"
	echo $COMMAND
	sudo nvidia-docker exec \
		-it \
		doshico_container $COMMAND
fi

# ----------------------------------------------
# TEST 4
# Skip this test if you don't have a Gazebo installed on your local machine
# Get GUI in local environment thanks to port forwarding
if [ $TEST = 4 ] ; then
	COMMAND="/bin/bash /ros_entrypoint.sh gzclient --verbose"
	echo $COMMAND
	sudo nvidia-docker exec \
		-it \
		doshico_container $COMMAND
fi

# ----------------------------------------------
# TEST 5
# If you run fedora or ubuntu, you can install Gazebo
# and run the client locally.
# You might have to adjust the IP and port number according
# to where the gzserver is publishing. Check this in the window
# of gzserver.
if [ $TEST = 5 ] ; then
	export GAZEBO_MASTER_IP=172.17.0.2
	export GAZEBO_MASTER_URI=$GAZEBO_MASTER_IP:11345
	gzclient --verbose
fi


# ----------------------------------------------
# TEST 6
# Check nvidia installation and drivers
if [ $TEST = 6 ] ; then
	COMMAND="nvidia-smi"
	echo $COMMAND
	sudo nvidia-docker exec \
		-it \
		doshico_container $COMMAND
# In case this doesn't work you probably have to set the $PATH
# environment variable to the correct location of the mounted drivers
# They should be mounted by nvidia-docker in /usr/local/nvidia/...
# export PATH=$PATH:/usr/local/nvidia/bin
# this should do the trick
fi



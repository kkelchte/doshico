#!/bin/bash
clear


# PLEASE NOTE
# We assume that you fulfulled step_one.sh before running this script
# Please run the script bellow within a doshico container.
# This can be done with the following command after setting the variables:
#	HOME_HOST=/home/klaas/docker_home
# HOME_CONT=/home/$USER
# sudo nvidia-docker run -it \
# 	--rm \
# 	-v $HOME_HOST:$HOME_CONT \
# 	-v /tmp/.X11-unix:/tmp/.X11-unix \
# 	--name doshico_container \
# 	doshico_image $HOME_CONT/step_two.sh
# Place this file in $HOME_HOST


echo ---------------------------------------------------------------------
echo
echo
echo 'Step 2: Installing and testing of the online performance by flying in ESAT simulated environment.'
echo
echo
echo ---------------------------------------------------------------------
echo
clone_git_in_container(){
	if [ ! -d $HOME/$1/src/$2 ] ; then
		mkdir -p $HOME/$1/scr
		cd $HOME/$1 && catkin_make
		cd $HOME/$1/scr
		git clone https://github.com/kkelchte/$2
		cd $HOME/$1 && catkin_make
		if [ ! -d $HOME/$1/src/$2 ] ; then
				echo "Something went wrong..."
				exit
			fi
	else
		echo "Found $2 @ $HOME/$1/src/$2"
	fi
}
echo
echo '--------: Create a catkin workspace for drone simulator :--------'
echo
clone_git_in_container drone_ws hector_quadrotor
echo
echo '--------: Create a catkin workspace for simulation supervised :--------'
echo
clone_git_in_container simsup_ws simulation_supervised
echo
echo "done"


#!/bin/bash
clear
INTERACTIVE=true
usage(){
	echo 
	echo "Testing and installation script. Options: -i true or false for interaction." 1>&2; exit 1; }
while getopts ":i:d:h:" o; do
case "${o}" in
	i)
		INTERACTIVE=${OPTARG} ;;
	h)
		usage ;;
	*)
		usage ;;
esac
done
shift $((OPTIND-1))

tput setaf 3 
echo ---------------------------------------------------------------------
echo
echo
echo "Step 1 file: Installing and testing of the offline training setting."
echo
echo
echo ---------------------------------------------------------------------
tput sgr 0
# SETUP

# Before running the script, we assume that you have installed and tested docker, nvidia-docker and nvidia
# by following the scripts you can find here:
# https://github.com/kkelchte/doshico/tree/master/assets/code
# In case you use a different username, please adjust bellow:
# Run this script on your local machine preferably in your HOME folder.
# In case you use a different path than $HOME for your docker home,
# please adjust the line bellow:
HOME_HOST="/home/$USER/docker_home"
# The docker home directory seen from the host account

#---------------------------------------------------------------------
HOME_CONT=/home/$USER
# The docker home directory seen from within the docker container

echo "user: $USER"
echo "home host: $HOME_HOST"
echo "home container: $HOME_CONT"

# Check requirements:
check_req(){
	if [ -z $(which ${1}) ] ; then
		echo "$(tput setaf 1)please install ${1}$(tput sgr 0)"
		exit
	fi
}
check_req wget
check_req unzip
check_req sed
check_req git

echo "requirements = ok"
echo
echo "--------: Create a pilot_data dir :--------"
mkdir -p $HOME_HOST/pilot_data
cd $HOME_HOST/pilot_data

download_and_extract_data(){
	if [ -d ${1} ] ; then
		echo "Found ${1} extracted and ready."
		return
	fi
	echo "--------: Get the training data of ${1} :--------"
	echo "@ $PWD"
	if [ -e ${1}.zip ] ; then
		echo "Found ${1}.zip."
	else
		echo "Downloading ${1}.zip."
		wget https://homes.esat.kuleuven.be/~kkelchte/data/pilot_data/${1}.zip
		if [ ! -e ${1}.zip ] ; then
			echo "$(tput setaf 1)Something went wrong with downloading ${1}.zip.$(tput sgr 0)"
			exit
		else
			echo "Downloaded ${1} successfully"
		fi
	fi
	if [ -d ${1} ] ; then
		echo "Found ${1} extracted."
	else
		echo "Extracting ${1}..."
		unzip ${1}.zip > /dev/null
		if [ ! -d ${1} ] ; then
			echo "$(tput setaf 1)Something went wrong with unzipping ${1}.zip.$(tput sgr 0)"
			exit
		else
			echo "Extracted ${1} successfully"
		fi
	fi
}

download_and_extract_data canyon_forest_sandbox
download_and_extract_data esat
download_and_extract_data almost_collision_set

if [ $(ls -l | grep .zip | wc -l) -gt 0 ] ; then 
	echo "--------: Remove zip files :--------"
	rm *.zip
fi

echo "--------: Prepare different datasets :--------"
mkdir -p overview
mkdir -p small

prepare_data(){
	rm overview/${2}_set.txt > /dev/null 2>&1
	for d in ${1}/* ; do
		if [ -d $d ] ; then
			echo $HOME_CONT/pilot_data/$d >> overview/${2}_set.txt;
		fi
	done
	rm small/${2}_set.txt > /dev/null 2>&1
	for d in $(ls ${1} | head -1) ; do
		if [ -d ${1}/$d ] ; then
			echo $HOME_CONT/pilot_data/${1}/$d >> small/${2}_set.txt
		fi
	done
	rm ${1}/${2}_set.txt
	for d in ${1}/* ; do
		if [ -d $d ] ; then
			echo $HOME_CONT/pilot_data/$d >> ${1}/${2}_set.txt
		fi
	done
}

prepare_data canyon_forest_sandbox train
prepare_data esat val
prepare_data almost_collision_set test
echo
echo "--------: Get log folder with the latest checkpoints :--------"
cd $HOME_HOST # get back to home folder
mkdir -p $HOME_HOST/tensorflow/log
cd $HOME_HOST/tensorflow/log
download_and_extract_model(){
	if [ -d ${1} ] ; then
		echo "Found ${1}"
	else
		if [ -e ${1}.zip ] ; then
			echo "Found ${1}.zip"
		else
			echo "Downloading..."
			echo "@ $PWD"
			wget https://homes.esat.kuleuven.be/~kkelchte/checkpoints/${1}.zip
			if [ ! -e ${1}.zip ] ; then
				echo "$(tput setaf 1)Something went wrong with downloading ${1}.zip$(tput sgr 0)"
			else
				echo "Successfully downloaded ${1}.zip."
			fi
		fi
		echo "Extracting..."
		unzip -p ${1} | tar -xf -
		if [ ! -d ${1} ] ; then
			echo "$(tput setaf 1)Something went wrong with extracting ${1}.$(tput sgr 0)"
		else
			echo "Extracted successfully ${1}."
		fi
	fi
}
download_and_extract_model mobilenet_025
download_and_extract_model naux
download_and_extract_model auxd

if [ $(ls -l | grep .zip | wc -l) -gt 0 ] ; then 
	echo '--------: Remove zip files :--------'
	rm *.zip
fi
echo
echo '--------: Prepare checkpoint paths :--------'
prepare_checkpoint(){
	if [ -e ${1}/checkpoint ] ; then
		sed -i 's,\/esat\/qayd\/kkelchte\/docker_home,'"$HOME_CONT"',' ${1}/checkpoint
		echo "Please check the following directory if it makes any sense within the docker container:"
		tail -1 ${1}/checkpoint
	else
		sed -i 's,\/esat\/qayd\/kkelchte\/docker_home,'"$HOME_CONT"',' ${1}/*/checkpoint
		echo "Please check the following directory if it makes any sense within the docker container:"
		tail -1 ${1}/*/checkpoint
	fi
}
prepare_checkpoint mobilenet_025
prepare_checkpoint naux
prepare_checkpoint auxd
echo "$(tput setaf 4)>> In case one of the lines didn't make sense adjust this in the text file: $PWD/model_name/../checkpoint$(tput sgr 0)"

echo
echo "--------: Get pilot :--------"
echo "get the tensorflow code required for offline training."
cd $HOME_HOST
mkdir -p $HOME_HOST/tensorflow
cd $HOME_HOST/tensorflow
if [ -d pilot ] ; then
	echo "Found pilot code"
else
	git clone https://www.github.com/kkelchte/pilot
	if [ ! -d pilot ] ; then
		echo "$(tput setaf 1)Something went wrong with donwloading pilot.$(tput sgr 0)"
		exit
	fi
fi
echo 'export PYTHONPATH=$PYTHONPATH:$HOME/tensorflow/pilot'>>$HOME_HOST/.bashrc
echo
echo "--------: Test the code step by step with docker image: doshico_image :--------"
test_in_docker_container(){
	if [ $INTERACTIVE = true ] ; then	
		read -p "$(tput setaf 2) skip? ([y]/n) $(tput sgr 0)" answer
		answer="_$answer"
		if [[ $answer == '_y' || $answer == '_' ]] ; then
			return
		fi
	fi
	sudo nvidia-docker run -it \
		--rm \
		-v $HOME_HOST:$HOME_CONT \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		--name doshico_container_step_one \
		doshico_image $@
}

###########
echo
echo "... test data.py: reading data.py"
test_command="python $HOME_CONT/tensorflow/pilot/pilot/data.py --num_threads 1"
test_in_docker_container $test_command
echo
echo "$(tput setaf 4) >> if everthing went well you should end with: loading time one episode...$(tput sgr 0)"
echo
###########
echo
echo "next: ... test main.py: training model from scratch on small dataset."
echo
test_command="python $HOME_CONT/tensorflow/pilot/pilot/main.py --max_episodes 3 --continue_training False --scratch True --num_threads 1"
test_in_docker_container $test_command
echo
echo "$(tput setaf 4) >> if everthing went well you should end with: loss_test_control: 1.237851 $(tput sgr 0)"
echo
###########
echo
echo "next: ... test main.py: training model from pretrained imagenet mobilenet_025 model."
echo
test_command="python $HOME_CONT/tensorflow/pilot/pilot/main.py --max_episodes 3 --continue_training False --num_threads 1"
test_in_docker_container $test_command
echo
echo "$(tput setaf 4) >> if everthing went well you should end with: loss_test_control: 1.7868835 $(tput sgr 0)"
echo
###########
echo
echo "next: ... test main.py: testing AUXD model on almost_collision_set."
echo
test_command="python $HOME_CONT/tensorflow/pilot/pilot/main.py --testing True --checkpoint_path auxd --dataset almost_collision_set --num_threads 1"
test_in_docker_container $test_command
echo
echo "$(tput setaf 4) >> if everthing went well you should end with: loss_test_control: 6.8241248 $(tput sgr 0)"
echo 
echo
tput setaf 4
echo "Alright, hopefully everything went well so far... If the results are not exactly the same,"
echo "that's probably due to different versions of random number generators. [random(2.7.12), numpy(1.13.1) and tensorflow(1.2.1)]"
echo
tput setaf 2
echo
echo "In order to train/validate your model online, you'll have to continue with step two which you can find here:"
echo "$HOME_HOST/tensorflow/pilot/scripts/step_two.sh"
echo "You should run this script within a doshico container. This can be achieved with the following command:"
echo "$(tput setaf 3)sudo nvidia-docker run -it --rm -v $HOME_HOST:$HOME_CONT -v /tmp/.X11-unix:/tmp/.X11-unix --name doshico_container doshico_image $HOME_CONT/tensorflow/pilot/scripts/step_two.sh -i true"
tput setaf 2
echo "Goodluck!"
tput sgr 0


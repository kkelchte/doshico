#!/bin/bash
clear

# Requirements:
# wget
# unzip

# Run this script on you local machine
echo 'Step 1: Installing and testing of the offline training setting.'

echo '--------: Create a pilot_data dir :--------'
mkdir -p pilot_data
cd pilot_data

download_and_extract(){
	echo "--------: Get the training data of ${1} :--------"
	if [ -e ${1}.zip ] ; then
		echo "Found ${1}.zip."
	else
		echo "Downloading ${1}.zip."
		wget https://homes.esat.kuleuven.be/~kkelchte/data/pilot_data/${1}.zip
	fi
	if [ ! -e ${1}.zip ] ; then
		echo "Something went wrong with downloading ${1}.zip."
		exit
	fi
	if [ -d ${1} ] ; then
		echo "Found ${1} extracted."
	else
		echo "Extracting ${1}..."
		unzip ${1}.zip > /dev/null
	if [ ! -d ${1} ] ; then
		echo "Something went wrong with unzipping ${1}.zip."
		exit
	fi
}

download_and_extract canyon_forest_sandbox
download_and_extract esat
download_and_extract almost_collision_set


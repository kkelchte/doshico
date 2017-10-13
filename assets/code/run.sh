# Run the image
# Ensure that $USER and $HOME are correct environment variables
# Check whether your graphic X11 mount point is in the /tmp folder

# Extra options:
#	--rm ~ remove container when it is closed. Best used when you don't plan to make changes to the docker image itself.



sudo nvidia-docker run -it \
	--rm \
	-v $HOME:/home/$USER \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	--name doshico_container \
	doshico_image bash

# if the name doshico_container is already used because you run this script for the second time
# use the following command to remove the container:
# $ sudo docker rm doshico_container

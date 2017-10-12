# Run the image
# Ensure that $USER and $HOME are correct environment variables
# Check whether your graphic X11 mount point is in the /tmp folder

sudo nvidia-docker run -it \
	--rm \
	-v $HOME:/home/$USER \
	-v /tmp/.X11-UNIX:/tmp/.X11-UNIX \
	--name doshico_container \
	doshico_image bash
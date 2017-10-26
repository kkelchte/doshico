# Run the running container as your image
# so the updates on system level in the container are not lost
# pick a version number to keep track of your changes

NUM=0.0
sudo docker commit doshico_container doshico_image:$NUM
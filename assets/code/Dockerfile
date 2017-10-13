# Image to build ros+gazebo+tensorflow ready for condor
FROM kkelchte/ros_gazebo_tensorflow

LABEL "com.nvidia.volumes.needed"="nvidia_driver"

# RUN apt update

ARG username
ARG uid
ARG gid
ARG display

# Please adjust UID, GID and USERNAME bellow
# you can find your id with command $ id
# It is a good idea to pick username as your own username.

RUN export uid=$uid gid=$gid username=$username && \
    echo "${username}:x:${uid}:${gid}:${username},,,:/home/${username}:/bin/bash" >> /etc/passwd && \
    echo "${username}:x:${uid}:" >> /etc/group

USER ${username}
ENV HOME /home/${username}
ENV DISPLAY ${display}
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/nvidia/lib64:/usr/local/cuda-8.0/lib64:/usr/local/cudnn/lib64
ENV PATH=$PATH:/usr/local/nvidia/bin
ENTRYPOINT ["./ros_entrypoint.sh"]

# Installing git clone could be done if you added a different home dir here:
# RUN mkdir -p /home/hidden_home/catkin_ws &&
#		cd /home/hidden_home/catkin_ws &&
#		catkinize &&
#		cd src &&
#		git clone drone_simulator &&
#		cd /home/hidden_home/catkin_ws &&
#		catkin_make
#		echo /home/hidden_home/catkin_ws/devel/setup.bash >> /ros_entrypoint.sh

# Make 



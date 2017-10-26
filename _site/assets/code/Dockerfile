# Image to build ros+gazebo+tensorflow ready for condor
FROM kkelchte/ros_gazebo_tensorflow

LABEL "com.nvidia.volumes.needed"="nvidia_driver"

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
ENV LD_LIBRARY_PATH=/usr/local/nvidia/lib64:/usr/local/cuda-8.0/lib64:/usr/local/cudnn/lib64:$LD_LIBRARY_PATH
ENV PATH=$PATH:/usr/local/nvidia/bin



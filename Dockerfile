FROM ubuntu:16.04


# LABEL maintainer="tombenke@gmail.com"
LABEL respository="https://github.com/tobyfoo/dmos"
# TODO: for pull request change this back to LABEL respository "https://github.com/tombenke/dmos"

ENV HOME /home/developer
ENV MOS_PORT /dev/ttyUSB0
WORKDIR /home/developer

# Replace 1000 with your user / group id
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    mkdir -p /etc/sudoers.d && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer && \
    apt-get update && \
    apt-get install -y \
    curl \
    sudo \
    git \
    cu \
    nano \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# Add developer user to the dialout group to be ale to write the serial USB device
RUN sed "s/^dialout.*/&developer/" /etc/group -i

# Add golang and simple proxy written in go to proxy mos ui out of the container 
# (because mos binds to 127.0.0.1:1992 and there is no way to configure it to allow external connections)
# Also add some useful tools like git and nano to the image
RUN apt -y update && apt -y install golang-go && apt clean
COPY proxy.go /home/developer
# inside the container, start the proxy with something like this: go run proxy.go &

USER developer
RUN sudo curl -fsSL https://mongoose-os.com/downloads/mos/install.sh | /bin/sh    
ENV PATH="${HOME}/.mos/bin/:${PATH}"
EXPOSE 9992


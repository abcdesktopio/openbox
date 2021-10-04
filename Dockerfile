
# Default release is 18.04
ARG BASE_IMAGE_RELEASE=18.04
# Default base image 
ARG BASE_IMAGE=ubuntu:18.04

# use FROM BASE_IMAGE
# define FROM befire use ENV command
FROM ${BASE_IMAGE}

# define ARG 
ARG BASE_IMAGE_RELEASE
ARG BASE_IMAGE

# set non interactive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
# enable source list
RUN sed -i '/deb-src/s/^# //' /etc/apt/sources.list 
# run update
RUN apt update
# install dev, dep and sources
RUN apt-get install -y fakeroot devscripts devscripts binutils wget
RUN apt-get build-dep -y openbox

COPY /openbox.title.patch .

RUN cat /etc/passwd

# Next command use $BUSER context
ENV BUSER builder
# RUN adduser --disabled-password --gecos '' $BUSER
# RUN id -u $BUSER &>/dev/null || 
RUN groupadd --gid 4096 $BUSER
RUN useradd --create-home --shell /bin/bash --uid 4096 -g $BUSER --groups sudo $BUSER
# hack: be shure to own the home dir 
RUN chown -R $BUSER:$BUSER /home/$BUSER

USER $BUSER
RUN cd /home/$BUSER && apt-get source openbox

RUN ls -la /

# get patch
RUN cd openbox-3.6.1 && patch -p2 < /openbox.title.patch 
    
# dch --local abcdesktop_sig_usr
RUN cd openbox-3.6.1 && dch -n abcdesktop_sig_usr

# dpkg-source --commit
RUN cd openbox-3.6.1 && \
    EDITOR=/bin/true dpkg-source -q --commit . abcdesktop_sig_usr 
    
RUN cd openbox-3.6.1 && \    
    debuild -us -uc
    
RUN ls -la *.deb
# copy your new deb to the oc.user directory 
# then rebuild your oc.user image 



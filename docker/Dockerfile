FROM ubuntu:18.04

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install gcc make nasm gcc-multilib gdb -y

VOLUME [ "/study_src" ]
WORKDIR /study_src
ENTRYPOINT [ "/usr/bin/make" ]

FROM ubuntu:18.04

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install gcc make nasm gcc-multilib gdb -y

COPY build.sh /build.sh

RUN chmod +x /build.sh

VOLUME [ "/study_src" ]

ENTRYPOINT [ "/bin/bash", "/build.sh" ]

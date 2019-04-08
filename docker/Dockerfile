FROM ubuntu:18.04

RUN apt update && \
    apt upgrade -y && \
    apt install gcc make nasm -y

COPY build.sh /build.sh

RUN chmod +x /build.sh

VOLUME [ "/study_src" ]

ENTRYPOINT [ "/bin/bash", "/build.sh" ]

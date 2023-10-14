FROM ubuntu:22.04

COPY ossutil restic /usr/local/bin

RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list && \
    apt update && \
    apt install -y vim openssl ssh telnet wget curl \
    net-tools traceroute tcpdump sysstat git \
    zip iputils-ping iproute2 rsync make \
    mysql-server redis netcat dnsutils tree

RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config && \
    echo "root:root" | chpasswd && \
    mkdir -p /var/run/sshd

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]

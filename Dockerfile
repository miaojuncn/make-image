FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN sed -i 's@http://archive.ubuntu.com@http://mirrors.aliyun.com@g' /etc/apt/sources.list && \
    apt update && apt install -y ssh sudo curl && \
    apt-get autoclean && apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config && \
    echo "root:123456" | chpasswd && \
    mkdir -p /var/run/sshd
#ADD run.sh /run.sh

EXPOSE 22

ENV CONDA_DIR=/opt/conda
RUN curl -sSL https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -b -p $CONDA_DIR \
    && rm /tmp/miniconda.sh
ENV PATH=$CONDA_DIR/bin:$PATH

COPY env.yaml /tmp/env.yaml

RUN conda env create -f /tmp/env.yaml && conda clean -afy
SHELL ["conda", "run", "-n", "chameile", "/bin/bash", "-c"]


CMD ["/usr/sbin/sshd", "-D"]

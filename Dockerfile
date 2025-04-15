FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y ssh sudo python3 python3-pip && ln -s /usr/bin/python3 /usr/bin/python && \
    apt-get autoclean && apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config && \
    echo "root:123456" | chpasswd && \
    mkdir -p /var/run/sshd

ADD run.sh /run.sh

EXPOSE 22

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt && pip install torch==1.12.1+cu116 torchvision==0.13.1+cu116 torchaudio==0.12.1 --extra-index-url https://download.pytorch.org/whl/cu116

ENTRYPOINT ["/run.sh"]
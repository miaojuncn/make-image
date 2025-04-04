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

RUN pip install torch==2.4.1 torchvision==0.19.1 torchaudio==2.4.1 --index-url https://download.pytorch.org/whl/cu118 && pip install --no-cache-dir -r requirements.txt

ENTRYPOINT ["/run.sh"]
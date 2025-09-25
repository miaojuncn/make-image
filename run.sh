#!/bin/bash

/usr/sbin/sshd
source /opt/conda/etc/profile.d/conda.sh
conda activate chameile
exec "$@"
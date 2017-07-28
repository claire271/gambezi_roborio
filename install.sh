#!/bin/bash

PORT=22
IP=10.17.47.2

scp -P $PORT gambezi.tar.gz admin@$IP:~/
scp -P $PORT install_gambezi.sh admin@$IP:~/
ssh -p $PORT admin@$IP '~/install_gambezi.sh'

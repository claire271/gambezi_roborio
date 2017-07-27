#!/bin/bash

PORT=10022
IP=localhost

scp -P $PORT gambezi.tar.gz admin@$IP:~/
scp -P $PORT install_gambezi.sh admin@$IP:~/
ssh -p $PORT admin@$IP '~/install_gambezi.sh'

#/bin/bash

cd ~
cd /usr/local/bin
./securecloud-cli stop
rm -rf securecloudd securecloud-cli securecloud-tx
wget https://github.com/securecloudnet/SecureCloud/releases/download/v2.4.0/SecureCloud-linux.tar.gz
tar -xzf SecureCloud-linux.tar.gz
rm -rf SecureCloud-linux.tar.gz
./securecloudd -daemon
sleep 30
./securecloud-cli getinfo

#/bin/bash

cd ~
cd /usr/local/bin

echo ""
echo Stoping Masternodes
echo ""

find /root -type f -iname "securecloud.conf"|grep -i ".securecloud"|grep -v "bak"|awk '{print "/usr/local/bin/securecloud-cli -conf="substr($0,1,length($0)) " -datadir="substr($0,1,length($0)-16) " stop"}'|sh

rm -rf securecloudd securecloud-cli securecloud-tx
wget https://github.com/securecloudnet/SecureCloud/releases/download/v2.4.3/SecureCloud-linux.tar.gz
tar -xzf SecureCloud-linux.tar.gz
rm -rf SecureCloud-linux.tar.gz
 
 masternode start-all 1


find /root -type f -iname "securecloud.conf"|grep -i ".securecloud"|grep -v "bak"|awk '{print "/usr/local/bin/securecloudd -daemon -conf="substr($0,1,length($0)) " -datadir="substr($0,1,length($0)-16) " -pid="substr($0,1,length($0)-13) "securecloud.pid"}'|sh
sleep 60
find /root -type f -iname "securecloud.conf"|grep -i ".securecloud"|grep -v "bak"|awk '{print "/usr/local/bin/securecloud-cli -conf="substr($0,1,length($0)) " -datadir="substr($0,1,length($0)-16) " masternode start-all 1"}'|sh
find /root -type f -iname "securecloud.conf"|grep -i ".securecloud"|grep -v "bak"|awk '{print "/usr/local/bin/securecloud-cli -conf="substr($0,1,length($0)) " -datadir="substr($0,1,length($0)-16) " masternode start local"}'|sh
find /root -type f -iname "securecloud.conf"|grep -i ".securecloud"|grep -v "bak"|awk '{print "/usr/local/bin/securecloud-cli -conf="substr($0,1,length($0)) " -datadir="substr($0,1,length($0)-16) " masternode status"}'|sh

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
 
echo ""
echo Starting Masternodes
echo ""

find /root -type f -iname "securecloud.conf"|grep -i ".securecloud"|grep -v "bak"|awk '{print "/usr/local/bin/securecloudd -daemon -conf="substr($0,1,length($0)) " -datadir="substr($0,1,length($0)-16) " -pid="substr($0,1,length($0)-13) "securecloud.pid"}'|sh

echo ""
echo Waiting for start Masternodes .....
echo ""
sleep 100

find /root -type f -iname "securecloud.conf"|grep -i ".securecloud"|grep -v "bak"|awk '{print "/usr/local/bin/securecloud-cli -conf="substr($0,1,length($0)) " -datadir="substr($0,1,length($0)-16) " masternode start-all 1"}'|sh
find /root -type f -iname "securecloud.conf"|grep -i ".securecloud"|grep -v "bak"|awk '{print "/usr/local/bin/securecloud-cli -conf="substr($0,1,length($0)) " -datadir="substr($0,1,length($0)-16) " masternode start local"}'|sh
find /root -type f -iname "securecloud.conf"|grep -i ".securecloud"|grep -v "bak"|awk '{print "/usr/local/bin/securecloud-cli -conf="substr($0,1,length($0)) " -datadir="substr($0,1,length($0)-16) " masternode status"}'|sh

echo ""
echo If you see errors when the script tried to activate the Masternodes you can run the following commands again and again if you required .....
echo ""

echo find /root -type f -iname "securecloud.conf"|grep -i ".securecloud"|grep -v "bak"|awk '{print "/usr/local/bin/securecloud-cli -conf="substr($0,1,length($0)) " -datadir="substr($0,1,length($0)-16) " masternode start-all 1"}'|sh
echo find /root -type f -iname "securecloud.conf"|grep -i ".securecloud"|grep -v "bak"|awk '{print "/usr/local/bin/securecloud-cli -conf="substr($0,1,length($0)) " -datadir="substr($0,1,length($0)-16) " masternode start local"}'|sh
echo find /root -type f -iname "securecloud.conf"|grep -i ".securecloud"|grep -v "bak"|awk '{print "/usr/local/bin/securecloud-cli -conf="substr($0,1,length($0)) " -datadir="substr($0,1,length($0)-16) " masternode status"}'|sh

#!/bin/bash
port=9191
rpcport=9291
USERHOME=`eval echo "~$USER"`
namemoney="securecloud"
configfile=$namemoney".conf"
pidfile=$namemoney".pid"
client=$namemoney"-cli"
server=$namemoney"d"
# Set these to change the version of SecureCloud to install
TARBALLNAME="SecureCloud-2.2.0-linux.tar.gz"
TARBALLURL="https://github.com/securecloudnet/SecureCloud/releases/download/2.2.                                                                                                            0/"$TARBALLNAME
BOOTSTRAPURL=""
BOOTSTRAPARCHIVE=""
BWKVERSION="1.0.0"
cant=1

echo  "
                                        ,#%%%%%%%%%(,
                                    .##########(((##%%%#.
                                  /%#########((***/####%%%/
                    ,/#%%%%##%%#/%(//((((##(((((((####//#%%%
                 #%%%##*######(((((((////((#(((((((########%%,
              *&%%%%########(((((((//*,.,,*((##(/((((#######%%
            ,&%%%%%#######((((((((/((/*,,**//(###((((((####(#%%%%&%(.
           %%%%%%%######(((((//////((//////////##/((((((###(##%%%%%%%%
          #%%%%#%#####((((((//***,********/////#(//*/(((((######%%%%%%&&&&.
         #&%%#(/#####((((((///**,,,,,,********///*,,*/(((((######%%%%%%%&&&%
        .&%%%%#######((((//****////*****////////(((#((((((((#####%%%%%%%&&&&&.
        ,&%%%##((####((((/**,*/(((//*****,,****///((#/((((((///((##%%%%%#%&&@&
    *&&&&%%%#/**/((#((((((/////((///**,,,,,,,,**///((/((((//*,,*((#%%%&&&&&&@@.
 ,%&&&&&&%%%%########(((((/////((//**,,......,,**//((/((((((//(((#%%%%%&&%##&@*
*@@&&&%%#############((((((////((//**,,,......,,*//((/((((((#####%%%%%&&&%/(&@,
@@@&%##(//*/((#######((((((///(((//***,,,..,,,***//((/(((((#####%%%%%%&&&&&&@@
@@&&%#(/*,**/((#######((((((//(#((/*****,,,*****//((((((((#####%###%%%%&&&&&@(
@@@&&%%#((((#####(///(##((((((/##((////******///////(/(((#######(/*/#%%&&&&@*
%@@@@&&%%%%%%%%#/(//((###((((((/(((((/////////////*,,/((#####%%%####%&&&&&&,
 &@@@&&&&&&&&%%%%%%#######((((((((((/**////////((((((((#####%%%%%#(#&&&&&*
   %@@@@&&&&&&&%%%%%%########((((((((((((((((((((((#(######%%%%%%%&&&&*
                                  SecureCloud "



echo ""
echo This script create multiple
echo Master Node for SCN Money.
echo ""

read -p "How many Master Nodes do you want? [1/x] :" cant

while :
do
  read -p "Are you sure do want to create "$cant" Master Nodes ? [Y/n] :" INPUT_                                                                                                            STRING
  case $INPUT_STRING in
    y)
        break
                ;;
    n)
        break
        ;;
        *)
                INPUT_STRING=y
                break
                ;;
  esac
done


# Check if we are root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root." 1>&2
   exit 1
fi

cd

# Install tools for dig and systemctl
echo "Preparing installation..."
apt-get install git dnsutils systemd -y > /dev/null 2>&1

# Check for systemd
systemctl --version >/dev/null 2>&1 || { echo "systemd is required. Are you usin                                                                                                            g Ubuntu 16.04?"  >&2; exit 1; }

# CHARS is used for the loading animation further down.
CHARS="/-\|"

if [ -z "$EXTERNALIP" ]; then
EXTERNALIP=`dig +short myip.opendns.com @resolver1.opendns.com`
fi

ipmn=$EXTERNALIP

echo "Installing dependencies."
apt-get -qq update
echo "Installing dependencies.."
apt-get -qq upgrade
echo "Installing dependencies..."
apt-get -qq autoremove
apt-get -qq install wget htop unzip
echo "Installing dependencies...."
apt-get -qq install build-essential && apt-get -qq install libtool autotools-dev                                                                                                             autoconf libevent-pthreads-2.0-5 automake && apt-get -qq install libssl-dev &&                                                                                                             apt-get -qq install libboost-all-dev && apt-get -qq install software-properties-                                                                                                            common && add-apt-repository -y ppa:bitcoin/bitcoin && apt update && apt-get -qq                                                                                                             install libdb4.8-dev && apt-get -qq install libdb4.8++-dev && apt-get -qq insta                                                                                                            ll libminiupnpc-dev && apt-get -qq install libqt4-dev libprotobuf-dev protobuf-c                                                                                                            ompiler && apt-get -qq install libqrencode-dev && apt-get -qq install git && apt                                                                                                            -get -qq install pkg-config && apt-get -qq install libzmq3-dev
apt-get -qq install aptitude
apt-get -qq install libevent-dev


echo "Creating Swap..."

swap_size="4G"

sudo fallocate -l $swap_size /swapfile
sleep 2
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo -e "/swapfile none swap sw 0 0" | sudo tee -a /etc/fstab > /dev/null 2>&1
sudo sysctl vm.swappiness=10
sudo sysctl vm.vfs_cache_pressure=50
echo -e "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf > /dev/null 2>&1
echo -e "vm.vfs_cache_pressure=50" | sudo tee -a /etc/sysctl.conf > /dev/null 2>                                                                                                            &1

# Install SCN daemon
wget $TARBALLURL
tar -xzvf $TARBALLNAME
rm $TARBALLNAME
mv ./securecloudd /usr/local/bin
mv ./securecloud-cli /usr/local/bin
mv ./securecloud-tx /usr/local/bin
rm -rf $TARBALLNAME


if [ $INPUT_STRING == "y" ]
then
    echo "Creating "$cant" Master Nodes"

    printf -v ini "%03d" 1
    printf -v cant "%03d" $cant

    dir="${USERHOME}/"

    if [ -z $cant -o $cant < 1 ]
     then
       printf -v cant "%03d" 1
    fi

    if [ -d $dir ]
      then

      dir="${USERHOME}/."$namemoney
      i=0
      for x in $( eval echo {$ini..$cant} )
      do
        i=$((i+1))

        echo "mkdir "$dir$x"/"|sh
        echo "rm "$dir$x"/*.conf"|sh

        newport=$((port + i))
        newportrpc=$((rpcport + i))

        RPCUSER=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1                                                                                                            )
        RPCPASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head                                                                                                             -n 1)

        echo "# Script Generated by Mutante" > $dir$x"/"$configfile
        echo "" >> $dir$x"/"$configfile

        if [ i > 1 ]
           then
           echo "listen=0" >> $dir$x"/"$configfile
        else
           echo "listen=1" >> $dir$x"/"$configfile
        fi

        echo "server=1" >> $dir$x"/"$configfile
        echo "daemon=1" >> $dir$x"/"$configfile
        echo "logtimestamps=1" >> $dir$x"/"$configfile
        echo "maxconnections=256" >> $dir$x"/"$configfile
        echo "staking=1" >> $dir$x"/"$configfile

        #Nodes
        echo "addnode=149.28.238.247" >> $dir$x"/"$configfile
        echo "addnode=45.77.59.64" >> $dir$x"/"$configfile
        echo "addnode=45.63.119.225" >> $dir$x"/"$configfile
        echo "addnode=45.76.131.16" >> $dir$x"/"$configfile

        #IP and Ports
        echo "rpcuser="$RPCUSER >> $dir$x"/"$configfile
        echo "rpcpassword="$RPCPASSWORD >> $dir$x"/"$configfile
        echo "rpcallowip=127.0.0.1" >> $dir$x"/"$configfile
        echo "externalip="$ipmn >> $dir$x"/"$configfile
        echo "bind="$ipmn >> $dir$x"/"$configfile
        echo "masternodeaddr="$ipmn >> $dir$x"/"$configfile
        echo "rpcport="$newportrpc >> $dir$x"/"$configfile
        echo "port="$newport >> $dir$x"/"$configfile

      done

      echo
      echo Creating new Wallets and Master Nodes Keys, save thats addresses
      echo

      for x in $( eval echo {$ini..$cant} )
      do

        ps -fea|grep -s "$dir$x"/"$configfile" |grep -v "grep"| awk '{ print "ki                                                                                                            ll -9 "$2 }'|sh
        echo $server" -datadir="$dir$x"  -conf="$dir$x"/"$configfile" -pid="$dir                                                                                                            $x"/"$pidfile" -reindex"|sh
        sleep $((30+x))

        echo ""
        echo Master Node Private Key:
        getmasternode=$client" -conf="$dir$x"/"$configfile
        mnpk=$(echo ""|awk -v cli="$getmasternode" '{cli" masternode genkey"|get                                                                                                            line ; print $0}')
        echo $mnpk

        echo "Wallet "$x" : "
        echo $client" -datadir="$dir$x"  -conf="$dir$x"/"$configfile" -pid="$dir                                                                                                            $x"/"$pidfile" getaccountaddress mn1"|sh
        echo ""
        echo "masternode=1" >> $dir$x"/"$configfile
        echo "masternodeprivkey="$mnpk >> $dir$x"/"$configfile

        echo "# Masternode config file" > $dir$x"/masternode.conf"
        echo "# Format: alias IP:port masternodeprivkey collateral_output_txid c                                                                                                            ollateral_output_index" >> $dir$x"/masternode.conf"
        echo "mn1 127.0.0.2:$newport $mnpk 0 0" >> $dir$x"/masternode.conf"

      done
    fi

      echo
      echo Now deposit the collaterals in new wallets and edit the masternodes.c                                                                                                            onf files updating the TXID
      echo and restart the services.
      echo
      echo Enjoy.
      echo
      echo Example of restart service:
      echo
      echo   STOP
      echo     $client "-conf=/root/."$namemoney"001/"$configfile" stop"
      echo
      echo   START
      echo     $server "-conf=/root/."$namemoney"001/"$configfile" -datadir=/roo                                                                                                            t/."$namemoney"001/ -pid=/root/."$namemoney"001/"$pidfile
fi


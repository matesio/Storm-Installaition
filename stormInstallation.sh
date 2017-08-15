#!/bin/bash


echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "@@@@@@@@@@@@@@@"$0"@@@@@@@@@@@@@@@"
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"


zook_dir=$1
storm_dir=$2


if [ ! -z $1 ] && [ ! -z $2  ];then
echo "---------------------------------------------------"
echo "---------------Installing zookeeper----------------"
echo "---------------------------------------------------"
des=/home/$USER/Desktop

cd $des
echo "Directory changed to"
pwd
#checking if zookeeper is installed or not 
if ! type "zkServer.sh" > /dev/null; then
echo "Zookeeper requirement already satisfied"
else
zookeeper_link='http://www-eu.apache.org/dist/zookeeper/zookeeper-3.4.10/zookeeper-3.4.10.tar.gz'
wget $zookeeper_link
tar xzf zookeeper-3.4.10.tar.gz
cd zookeeper-3.4.10

sudo mkdir  $1/zookeeper
sudo mv * $1/zookeeper

sudo cp $1/zookeeper/conf/zoo_sample.cfg  $1/zookeeper/conf/zoo.cfg

echo "-------------------------------------------------"
echo ">>> appending zookeeper path to profile variables"
echo "-------------------------------------------------"
sudo echo "export ZOOKEEPER_PREFIX=$1/zookeeper
      export PATH=$PATH:$ZOOKEEPER_PREFIX/bin" >> ~/.bashrc

echo "saving configurations"

source ~/.bashrc

echo "Starting zookeeper service"

zkServer.sh start

echo "------------------------------------------------------------"
echo "-------------zookeeper installed successfuly----------------"
echo "------------------------------------------------------------"
fi
echo "------------------------------------------------------------"
echo ">>>Storm installation"
echo "------------------------------------------------------------"
cd $des
mkdir storm
cd storm
storm_link = wget http://www-us.apache.org/dist/storm/apache-storm-1.1.1/apache-storm-1.1.1.tar.gz

wget $storm_link

cd apache-storm-1.1.1/
sudo mkdir $2/storm
sudo mv * $2/storm

sudo echo "yaml storm.zookeeper.servers:
 - "localhost"
 yaml storm.local.dir: "/var/storm"
 yaml nimbus.host: "graylog2"
 yaml supervisor.slots.ports:
 - 6700 - 6701 - 6702 - 6703" >> $2/storm/conf/storm.yaml


#adding to user profile
sudo echo "export STORM_PREFIX=$2/storm
      export PATH=$PATH:$STORM_PREFIX/bin" >> ~/.bashrc

#installing xterm for command sessions
sudo apt-get install xterm

echo ">>>starting main server node"
xterm -e storm nimbus &

#starting storm supervisor
echo ">>>starting supervisor"
xterm -e storm supervisor &

#starting gui

echo ">>>starting storm gui localhost:8080"

xterm -e storm  ui &
#end if 

else
echo "usage: ./stormInstallation.sh <zookeeper installation directory>   <storm installation directory>"


fi

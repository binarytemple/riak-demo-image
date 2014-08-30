#!/usr/bin/env bash

sudo apt-get update --fix-missing
sudo apt-get install openssh-server -y

### riak demo box setup

## change to root
sudo su -

## ubuntu tuning

# set ulimits
echo \
"* soft nofile 65536
* hard nofile 65536
root soft nofile 65536
root hard nofile 65536" \
>> /etc/security/limits.conf

echo \
"session    required    pam_limits.so" \
>> /etc/pam.d/common-session

echo \
"session    required    pam_limits.so" \
>> /etc/pam.d/common-session-noninteractive

# set these values in sysctl.conf
echo \
"vm.swappiness=0
net.core.wmem_default=8388608
net.core.rmem_default=8388608
net.core.wmem_max=8388608
net.core.rmem_max=8388608
net.core.netdev_max_backlog=10000
net.core.somaxconn=4000
net.ipv4.tcp_max_syn_backlog=40000
net.ipv4.tcp_fin_timeout=15
net.ipv4.tcp_tw_reuse=1
net.core.rmem_max = 134217728
net.core.wmem_max = 134217728
net.ipv4.tcp_mem  = 134217728 134217728 134217728
net.ipv4.tcp_rmem = 4096 277750 134217728
net.ipv4.tcp_wmem = 4096 277750 134217728
net.core.netdev_max_backlog = 300000" \
>> /etc/sysctl.conf

# make changes effective
sysctl -p

## installation

# update apt-get
apt-get update --fix-missing

# install some useful tools
apt-get install curl vim git figlet -y

# install pre-reqs for erlang
apt-get install build-essential libncurses5-dev openssl libssl-dev fop xsltproc unixodbc-dev -y

# download and install erlang
cd
wget http://s3.amazonaws.com/downloads.basho.com/erlang/otp_src_R16B02-basho5.tar.gz
tar zxvf otp_src_R16B02-basho5.tar.gz
cd otp_src_R16B02-basho5
./configure && make && make install
cd
rm -rf otp_src_R16B02-basho5 otp_src_R16B02-basho5.tar.gz

# clone and install basho_bench
cd
git clone git://github.com/basho/basho_bench.git
cd basho_bench
make

# install riak dependencies
apt-get install libpam0g-dev -y

# clone and install riak
cd /
git clone git://github.com/basho/riak.git
cd riak
make rel
make devrel DEVNODES=5

# modify riak.conf
find /riak -name riak.conf | grep dev | xargs sed \
-e "s/## ring_size = 64/ring_size = 16/" \
-e "s/## strong_consistency = on/strong_consistency = on/" \
-e "s/storage_backend = bitcask/storage_backend = leveldb/" \
-e "s/search = off/search = on/" \
-e "s/search.solr.jvm_options = -d64 -Xms1g -Xmx1g -XX:+UseStringCache -XX:+UseCompressedOops/search.solr.jvm_options = -d64 -Xms128m -Xmx128m -XX:+UseStringCache -XX:+UseCompressedOops/" \
-i.bak

# change sshd config to PermitRootLogin yes
sed -e "s/PermitRootLogin without-password/PermitRootLogin yes/" /etc/ssh/sshd_config
service ssh restart

# set root password
echo "root:basho" | chpasswd

# install ruby client
apt-get install ruby1.9.1 -y && gem install riak-client

# try to minimise VM size
dd if=/dev/zero of=/EMPTY bs=1M
rm -rf /EMPTY

# shutdown after setup
shutdown -h now

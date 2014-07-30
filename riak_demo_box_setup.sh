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
* hard nofile 65536" \
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
wget http://erlang.org/download/otp_src_R15B01.tar.gz
tar zxvf otp_src_R15B01.tar.gz
cd otp_src_R15B01
./configure && make && make install
cd
rm -rf otp_src_R15B01 otp_src_R15B01.tar.gz

# clone and install basho_bench
cd
git clone git://github.com/basho/basho_bench.git
cd basho_bench
make

# get signing key
curl http://apt.basho.com/gpg/basho.apt.key | apt-key add -

# add basho repo
echo deb http://apt.basho.com $(lsb_release -sc) main > /etc/apt/sources.list.d/basho.list
apt-get update

# install riak
apt-get install riak -y

# modify app.config
sed -e "s/127.0.0.1/0.0.0.0/g" \
         -e "s/%{ring_creation_size, 64}/{ring_creation_size, 16}/" \
         -e "s/riak_kv_bitcask_backend/riak_kv_eleveldb_backend/" \
         -i.bak /etc/riak/app.config

# set root password
echo "root:basho" | chpasswd

# set motd
figlet riak demo > /etc/motd.tail

# echo some useful dev info to a file
cd
echo \
"Riak For Developers
===================

The following clients are installed and ready 
for testing with Riak on this demo instance:

Erlang - /riak-erlang-client
Java - /riak-java-client
PHP - /riak-php-client
Python - pip search riak
Ruby - gem list --local riak-client

For guides to help you with your first interaction with Riak 
check out http://docs.basho.com/riak/latest/dev/taste-of-riak/

" \
> Riak_For_Developers.README

# echo some useful ops info to a file
cd
echo \
"Riak For Operators
==================

Usage: riak {start | stop| restart | reboot | ping | console | attach | 
                    attach-direct | ertspath | chkconfig | escript | version | 
                    getpid | top [-interval N] [-sort reductions|memory|msg_q] [-lines N] }

Usage: riak-admin { cluster | join | leave | backup | restore | test | 
                    reip | js-reload | erl-reload | wait-for-service | 
                    ringready | transfers | force-remove | down |
                    cluster-info | member-status | ring-status | vnode-status |
                    aae-status | diag | status | transfer-limit | reformat-indexes |
                    top [-interval N] [-sort reductions|memory|msg_q] [-lines N] |
                    downgrade-objects | repair-2i }

File Locations:
Configuration files: /etc/riak
Data files: /var/lib/riak
Log files: /var/log/riak

Ports:
HTTP Port: 8098
Protocol Buffers Port: 8087

See http://docs.basho.com for further guidance on 
cluster installation, tuning and management.

Basho Bench
-----------

Basho Bench is a load generation tool provided for performance testing a cluster.
Basho Bench is included on this demo instance to allow familiarisation with the
configuration of benchmarking scenarios. Performance characteristics of a single
development node running in Virtualbox should not be considered representative of
achievable performance on any other hardware. 

" \
> Riak_For_Operators.README

# add some more useful MOTD info here
echo \
"A single node Riak cluster is installed and running on this system.

Non-default configuration specific to this demo instance:
- ring creation size has been changed from 64 to 16.
- storage backend has been changed from Bitcask to LevelDB.

Search docs.basho.com for more information on these configuration options.

Review the README files for Developers and Operators for more information:
- /root/Riak_For_Developers.README
- /root/Riak_For_Operators.README

" \
>> /etc/motd.tail


## install riak clients and any supporting code from docs.basho.com

# get java client
cd && mkdir riak-java-client && cd riak-java-client
wget http://riak-java-client.s3.amazonaws.com/riak-client-1.1.4-jar-with-dependencies.jar https://github.com/basho/basho_docs/raw/master/source/data/TasteOfRiak.java

# install python client
apt-get install python-pip -y && pip install riak

# install ruby client
apt-get install ruby1.9.1 -y && gem install riak-client

# install erlang client
cd
apt-get install erlang-parsetools erlang-dev erlang-syntax-tools -y
git clone git://github.com/basho/riak-erlang-client.git
cd riak-erlang-client && make

# install php client
cd
apt-get install php5-cli php5-curl -y
git clone git://github.com/basho/riak-php-client.git

# shutdown after setup
shutdown -h now

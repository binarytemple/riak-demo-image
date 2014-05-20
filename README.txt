Riak Demo
=========


Contents
--------

This USB stick contains an Ubuntu 12.04 LTS virtual machine appliance (basho_riak.ova).

The image has the following software pre-installed to allow easy testing of Riak 1.4.8:
- Riak 1.4.8
- Basho Bench
- Riak Clients
  - Erlang
  - Java
  - PHP 
  - Python 
  - Ruby


Installation
------------

If VirtualBox is not already installed, use one of the included installers 
or source the correct installation media for your version of Linux or other OS.

Once VirtualBox is installed and running, choose File > Import Appliance from
the VirtualBox menu, and follow the wizard selecting basho_riak.ova as the
appliance to import.

Start the virtual appliance and at the login prompt use the following credentials:
Username: riak
Password: basho


Notes
-----

Non-default configuration specific to this demo instance:
- ring creation size has been changed from 64 to 16.
- storage backend has been changed from Bitcask to LevelDB.

Search docs.basho.com for more information on these configuration options.

Review the README files for Developers and Operators for more information:
Riak_For_Developers_README.txt
Riak_For_Operators_README.txt

Also included are OSX and Windows installers for VirtualBox 4.3.12.
- VirtualBox-4.3.12-93733-OSX.dmg
- VirtualBox-4.3.12-93733-Win.exe
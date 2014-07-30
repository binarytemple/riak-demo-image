Riak For Operators
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


#Access to zookeper
./bin/zookeeper-shell.sh localhost:2181

#List root
ls /

#list brokers ids
ls /brokers/ids

#Read data from znode
get /brokers/ids/1


#Access to zookeper
./bin/zookeeper-shell.sh localhost:2181

#List root
ls /

#list brokers ids
ls /brokers/ids

#Read data from znode
get /brokers/ids/1

#Create Znode
create /leonardo "Hello Leonardo"

#Update data in znode
set /leonardo "Leonardo Updated data"

#Delete a znode
delete /leonardo

#Watch node
get -w /brokers/ids/1
get -w /brokers/topics/datagen-topic 

#Check ensemble status
echo "stat" | nc localhost 2181

#Create ephemereal znode 
create -e /leonardo_ephemeral_node "Leonardo temporary data"
get /leonardo_ephemeral_node
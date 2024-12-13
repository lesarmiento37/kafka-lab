## Install Java
sudo apt update
sudo apt install openjdk-11-jdk -y
java -version

## Install Kafka
wget https://downloads.apache.org/kafka/3.9.0/kafka_2.12-3.9.0.tgz
tar -xzf kafka_2.12-3.9.0.tgz
ln -s kafka_2.12-3.9.0 kafka

# Start Kafka
~/kafka/bin/zookeeper-server-start.sh -daemon ~/kafka/config/zookeeper.properties
tail -n 100 ~/kafka/logs/zookeeper.out
~/kafka/bin/kafka-server-start.sh -daemon ~/kafka/config/server.properties
tail -n 100 ~/kafka/logs/kafkaServer.out

# Stop Kafka
~/kafka/bin/zookeeper-server-stop.sh
~/kafka/bin/kafka-server-stop.sh


#Create Topic
./bin/kafka-topics.sh --create --topic test-topic --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1
./bin/kafka-topics.sh --create --topic outside-topic --bootstrap-server 54.157.175.115:9092 --partitions 1 --replication-factor 1
~/kafka/bin/kafka-topics.sh --create --topic test-topic --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1
# Create producer
./bin/kafka-console-producer.sh --topic test-topic --bootstrap-server localhost:9092
~/kafka/bin/kafka-console-producer.sh --topic test-topic --bootstrap-server localhost:9092

# Create consumer
./bin/kafka-console-consumer.sh --topic test-topic --bootstrap-server localhost:9092 --from-beginning
~/kafka/bin/kafka-console-consumer.sh --topic test-topic --bootstrap-server localhost:9092 --from-beginning
#DNS
ec2-54-157-175-115.compute-1.amazonaws.com

./bin/kafka-configs.sh --zookeeper ec2-54-157-175-115.compute-1.amazonaws.com:2181 --alter --add-config 'SCRAM-SHA-512=[password='admin-secret']' --entity-type users --entity-name admin

KafkaServer {
org.apache.kafka.common.security.scram.ScramLoginModule required
username="admin"
password="admin-secret";
};

security.protocol=SASL_SSL
sasl.mechanism=SCRAM-SHA-512
sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required username="admin" password="admin-secret";

ssl.keystore.location=/home/ubuntu/ssl/kafka.server.keystore.jks
ssl.keystore.password=leonardo
ssl.key.password=leonardo
ssl.truststore.location=/home/ubuntu/ssl/kafka.server.truststore.jks
ssl.truststore.password=leonardo

export KAFKA_OPTS=-Djava.security.auth.login.config=/home/ubuntu/kafka/config/kafka_server_jaas.conf

./bin/kafka-topics.sh --create --bootstrap-server ec2-54-157-175-115.compute-1.amazonaws.com:9094 --command-config ./config/ssl-user-config.properties --replication-factor 1 --partitions 1 --topic demo-topic

# Enable SSL Encryption

./bin/kafka-console-producer.sh --broker-list ec2-54-157-175-115.compute-1.amazonaws.com:9093 --producer.config client.properties --topic leonardo-topic



#server.properties

listeners=SASL_PLAINTEXT://:9093
advertised.listeners=SASL_PLAINTEXT://localhost:9093
listener.security.protocol.map=SASL_PLAINTEXT:SASL_PLAINTEXT
inter.broker.listener.name=SASL_PLAINTEXT

# SASL Mechanism
sasl.enabled.mechanisms=PLAIN
sasl.mechanism.inter.broker.protocol=PLAIN

ssl.keystore.location=/root/kafka/kafka.server.keystore.jks
ssl.keystore.password=leonardo
ssl.key.password=leonardo
ssl.truststore.location=/root/kafka/kafka.server.truststore.jks
ssl.truststore.password=leonardo
#ssl.client.auth=required

./bin/kafka-server-start.sh /config/server.properties
./bin/kafka-server-stop.sh /config/server.properties

# client.properties
security.protocol=SASL_PLAINTEXT
sasl.mechanism=PLAIN
sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username=leonardo password=leonardo-secret;


####server jasss
KafkaServer {
    org.apache.kafka.common.security.plain.PlainLoginModule required
    username="admin"
    password="leonardo-secret"
    user_admin="leonardo"
    user_user="leonardo-secret";
};
export KAFKA_OPTS="-Djava.security.auth.login.config=/root/kafka/config/kafka_server_jaas.conf"


###Client jass
nano /root/kafka/config/kafka_client_jaas.conf

KafkaClient {
    org.apache.kafka.common.security.plain.PlainLoginModule required
    username="leonardo"
    password="leonardo-secret";
};

export KAFKA_OPTS="-Djava.security.auth.login.config=/root/kafka/config/kafka_client_jaas.conf"

./bin/kafka-console-producer.sh --bootstrap-server ec2-54-157-175-115.compute-1.amazonaws.com:9093 --topic leonardo-topic --producer.config config/client.properties

./bin/kafka-console-producer.sh --bootstrap-server localhost:9093 --topic test-topic --producer.config config/client.properties

./bin/kafka-topics.sh --create --topic leonardo-ssl-topic --bootstrap-server ec2-54-157-175-115.compute-1.amazonaws.com:9093 --partitions 1 --replication-factor 1 --command-config  config/client.properties

sudo chmod 600 /home/ubuntu/ssl/ca-cert
sudo chmod 600 /home/ubuntu/ssl/ca-key
sudo chmod 600 /home/ubuntu/ssl/cert-file
sudo chmod 600 /home/ubuntu/ssl/cert-signed
sudo chmod 600 /home/ubuntu/ssl/kafka.server.keystore.jks
sudo chmod 600 /home/ubuntu/ssl/kafka.server.truststore.jks

sudo keytool -list -v -keystore /home/ubuntu/ssl/kafka.server.keystore.jks -storepass leonardo
sudo keytool -list -v -keystore /home/ubuntu/ssl/kafka.server.truststore.jks -storepass leonardo

openssl s_client -connect ec2-54-157-175-115.compute-1.amazonaws.com:9093 -cipher ECDHE-RSA-AES128-GCM-SHA256

TLS_AES_256_GCM_SHA384,TLS_CHACHA20_POLY1305_SHA256,TLS_AES_128_GCM_SHA256,ECDHE-ECDSA-AES256-GCM-SHA384,ECDHE-RSA-AES256-GCM-SHA384,DHE-RSA-AES256-GCM-SHA384,ECDHE-ECDSA-CHACHA20-POLY1305,ECDHE-RSA-CHACHA20-POLY1305,DHE-RSA-CHACHA20-POLY1305,ECDHE-ECDSA-AES128-GCM-SHA256,ECDHE-RSA-AES128-GCM-SHA256,DHE-RSA-AES128-GCM-SHA256

./bin/kafka-topics.sh --create \
    --command-config client.properties \
    --bootstrap-server ec2-54-157-175-115.compute-1.amazonaws.com:9093 \
    --replication-factor 1 \
    --partitions 1 \
    --topic ssl-leonardo-topic

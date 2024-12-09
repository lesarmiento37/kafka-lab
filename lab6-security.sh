#Create Topic
./bin/kafka-topics.sh --create --topic test-topic --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1
# Create producer
./bin/kafka-console-producer.sh --topic test-topic --bootstrap-server localhost:9092
# Create consumer
./bin/kafka-console-consumer.sh --topic test-topic --bootstrap-server localhost:9092 --from-beginning
# Enable SSL Encryption

keytool -keystore kafka.server.keystore.jks -alias localhost -keyalg RSA -validity 365 -genkey

openssl genrsa -out ca-key.pem 2048

openssl req -x509 -new -nodes -key ca-key.pem -sha256 -days 365 -out ca-cert.pem

openssl x509 -req -CA ca-cert.pem -CAkey ca-key.pem -in cert-file -out cert-signed.pem -days 365 -CAcreateserial

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

./bin/kafka-console-producer.sh --bootstrap-server localhost:9093 --topic leonardo-topic --producer.config config/client.properties

./bin/kafka-console-producer.sh --bootstrap-server localhost:9093 --topic test-topic --producer.config config/client.properties

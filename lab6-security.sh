#Create Topic
./bin/kafka-topics.sh --create --topic test-topic --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1
# Create producer
./bin/kafka-console-producer.sh --topic test-topic --bootstrap-server localhost:9092
# Create consumer
./bin/kafka-console-consumer.sh --topic test-topic --bootstrap-server localhost:9092 --from-beginning
# Enable SSL Encryption
keytool -keystore kafka.server.keystore.jks -alias localhost -keyalg RSA -validity 365 -genkey


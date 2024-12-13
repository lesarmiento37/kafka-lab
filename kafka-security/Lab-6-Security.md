
# Step-by-Step Guide: Installing and Configuring Kafka with SSL and SASL Authentication

## Step 1: Install Java
1. Update the package list:
   ```bash
   sudo apt update
   ```
2. Install OpenJDK 11:
   ```bash
   sudo apt install openjdk-11-jdk -y
   ```
3. Verify the installation:
   ```bash
   java -version
   ```

## Step 2: Install Kafka
1. Download Kafka:
   ```bash
   wget https://downloads.apache.org/kafka/3.9.0/kafka_2.12-3.9.0.tgz
   ```
2. Extract the Kafka archive:
   ```bash
   tar -xzf kafka_2.12-3.9.0.tgz
   ```
3. Create a symbolic link for easier access:
   ```bash
   ln -s kafka_2.12-3.9.0 kafka
   ```

## Step 3: Start Kafka
1. Start the ZooKeeper server:
   ```bash
   ~/kafka/bin/zookeeper-server-start.sh -daemon ~/kafka/config/zookeeper.properties
   ```
   View ZooKeeper logs:
   ```bash
   tail -n 100 ~/kafka/logs/zookeeper.out
   ```
2. Start the Kafka server:
   ```bash
   ~/kafka/bin/kafka-server-start.sh -daemon ~/kafka/config/server.properties
   ```
   View Kafka logs:
   ```bash
   tail -n 100 ~/kafka/logs/kafkaServer.out
   ```

## Step 4: Stop Kafka
1. Stop the ZooKeeper server:
   ```bash
   ~/kafka/bin/zookeeper-server-stop.sh
   ```
2. Stop the Kafka server:
   ```bash
   ~/kafka/bin/kafka-server-stop.sh
   ```

## Step 5: Create a Topic
1. Create a local topic:
   ```bash
   ./bin/kafka-topics.sh --create --topic test-topic --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1
   ```
2. Create a remote topic:
   ```bash
   ./bin/kafka-topics.sh --create --topic outside-topic --bootstrap-server 54.157.175.115:9092 --partitions 1 --replication-factor 1
   ```

## Step 6: Produce Messages
1. Start a producer for a topic:
   ```bash
   ./bin/kafka-console-producer.sh --topic test-topic --bootstrap-server localhost:9092
   ```

## Step 7: Consume Messages
1. Start a consumer for a topic:
   ```bash
   ./bin/kafka-console-consumer.sh --topic test-topic --bootstrap-server localhost:9092 --from-beginning
   ```

## Step 8: Configure SASL Authentication
1. Add SCRAM-SHA-512 authentication:
   ```bash
   ./bin/kafka-configs.sh --zookeeper ec2-54-157-175-115.compute-1.amazonaws.com:2181 --alter --add-config 'SCRAM-SHA-512=[password="admin-secret"]' --entity-type users --entity-name admin
   ```

2. Update `kafka_server_jaas.conf`:
   ```properties
   KafkaServer {
       org.apache.kafka.common.security.scram.ScramLoginModule required
       username="admin"
       password="admin-secret";
   };
   ```

3. Set Kafka environment variable:
   ```bash
   export KAFKA_OPTS=-Djava.security.auth.login.config=/home/ubuntu/kafka/config/kafka_server_jaas.conf
   ```

## Step 9: Configure SSL
1. Add SSL settings to `server.properties`:
   ```properties
   ssl.keystore.location=/home/ubuntu/ssl/kafka.server.keystore.jks
   ssl.keystore.password=leonardo
   ssl.key.password=leonardo
   ssl.truststore.location=/home/ubuntu/ssl/kafka.server.truststore.jks
   ssl.truststore.password=leonardo
   ```

2. Start Kafka with SSL:
   ```bash
   ./bin/kafka-server-start.sh /config/server.properties
   ```

## Step 10: Test SSL Connection
1. Check the SSL setup:
   ```bash
   openssl s_client -connect ec2-54-157-175-115.compute-1.amazonaws.com:9093
   ```

2. Create a topic with SSL:
   ```bash
   ./bin/kafka-topics.sh --create --topic ssl-leonardo-topic --bootstrap-server ec2-54-157-175-115.compute-1.amazonaws.com:9093 --partitions 1 --replication-factor 1 --command-config config/client.properties
   ```
## Results:
leonardo
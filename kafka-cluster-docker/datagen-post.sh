docker exec -it kafka1 kafka-topics \
  --create \
  --topic datagen-topic \
  --partitions 10 \
  --replication-factor 3 \
  --bootstrap-server kafka1:29092

docker exec -it kafka1 kafka-topics \
  --describe \
  --topic datagen-topic \
  --bootstrap-server kafka1:29092

curl -X POST -H "Content-Type: application/json" --data '{
    "name": "datagen-connector",
    "config": {
      "connector.class": "io.confluent.kafka.connect.datagen.DatagenConnector",
      "kafka.topic": "datagen-topic",
      "quickstart": "users",
      "tasks.max": "1",
      "key.converter": "org.apache.kafka.connect.storage.StringConverter",
      "value.converter": "org.apache.kafka.connect.json.JsonConverter"
    }
  }' http://localhost:8083/connectors
  

docker exec -it kafka1 kafka-console-consumer \
  --bootstrap-server kafka1:29092,kafka2:29093,kafka3:29094 \
  --topic datagen-topic \
  --partition 2 \
  --from-beginning

docker exec -it kafka1 kafka-topics \
  --bootstrap-server kafka1:29092 \
  --topic datagen-topic \
  --describe


docker exec -it kafka1 kafka-console-consumer \
  --bootstrap-server  kafka1:29092,kafka2:29093,kafka3:29094 \
  --topic datagen-topic \
  --group my-consumer-group \
  --from-beginning

docker exec -it kafka1 kafka-consumer-groups \
  --bootstrap-server kafka1:29092,kafka2:29093,kafka3:29094 \
  --list

docker exec -it kafka1 kafka-consumer-groups \
  --bootstrap-server kafka1:29092,kafka2:29093,kafka3:29094 \
  --group my-consumer-group \
  --describe

docker exec -it kafka1 bash
ls -lh /var/lib/kafka/data/datagen-topic/

#Check log configuration
cat /etc/kafka/server.properties | grep log

#Check Segment log
cat  /var/lib/kafka/data/datagen-topic-0/00000000000000000000.log

#Check Segment log more clearly
docker exec -it kafka1 kafka-dump-log \
  --files /var/lib/kafka/data/datagen-topic-0/00000000000000000000.log \
  --print-data-log



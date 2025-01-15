docker exec -it kafka1 kafka-topics \
  --create \
  --topic first_topic \
  --partitions 10 \
  --replication-factor 3 \
  --bootstrap-server kafka1:29092

docker exec -it kafka1 kafka-topics \
  --create \
  --topic second_topic \
  --partitions 10 \
  --replication-factor 3 \
  --bootstrap-server kafka1:29092

# producing with properties
docker exec -it kafka1 kafka-console-producer.sh \
    --bootstrap-server kafka1:29092 \
    --topic first_topic \
    --producer-property acks=all

# produce with keys
docker exec -it kafka1 kafka-console-producer \
    --bootstrap-server kafka1:29092 \
    --topic first_topic \
    --property parse.key=true \
    --property key.separator=:
name:Leonardo

# consuming from beginning
docker exec -it kafka1 kafka-console-consumer \
    --bootstrap-server kafka1:29092 \
    --topic first_topic \
    --from-beginning

# display key, values and timestamp in consumer
docker exec -it kafka1 kafka-console-consumer \
    --bootstrap-server kafka1:29092 \
    --topic first_topic \
    --formatter kafka.tools.DefaultMessageFormatter \
    --property print.timestamp=true \
    --property print.key=true \
    --property print.value=true \
    --from-beginning

# start one consumer
docker exec -it kafka1 kafka-console-consumer \
    --bootstrap-server kafka1:29092 \
    --topic first_topic \
    --group my-first-application

# list consumer groups
docker exec -it kafka1 kafka-consumer-groups \
    --bootstrap-server kafka1:29092 \
    --list

# describe one specific group
docker exec -it kafka1 kafka-consumer-groups \
    --bootstrap-server kafka1:29092 \
    --describe \
    --group my-first-application

# Delete topic
docker exec -it kafka1 kafka-topics --delete \
    --bootstrap-server kafka1:29092 \
    --topic second_topic


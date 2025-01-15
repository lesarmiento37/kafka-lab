#!/bin/bash

# create our topic with appropriate configs
kafka-topics.sh --bootstrap-server localhost:9092 --create --topic employee-salary --partitions 1 --replication-factor 1 --config cleanup.policy=compact --config min.cleanable.dirty.ratio=0.001 --config segment.ms=5000

# Describe Topic Configs
kafka-topics.sh --bootstrap-server localhost:9092 --describe --topic employee-salary

# in a new tab, we start a consumer
kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic employee-salary --from-beginning --property print.key=true --property key.separator=,

# we start pushing data to the topic
kafka-console-producer.sh --bootstrap-server localhost:9092 --topic employee-salary --property parse.key=true --property key.separator=,
> Patrick,salary: 10000
> Lucy,salary: 20000
> Bob,salary: 20000
> Patrick,salary: 25000
> Lucy,salary: 30000
> Patrick,salary: 30000

# Wait a minute, and produce a few more messages (it could be the same messages)
> Stephane,salary: 0

# Stop the Kafka console consumer and start a new one. We are fetching all the messages from the beginning. We should see only the unique keys with their corresponding latest values.
kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic employee-salary --from-beginning --property print.key=true --property key.separator=,

# Replace "kafka-topics.sh" 
# by "kafka-topics" or "kafka-topics.bat" based on your system # (or bin/kafka-topics.sh or bin\windows\kafka-topics.bat if you didn't setup PATH / Environment variables)

# list topics
kafka-topics.sh --bootstrap-server localhost:9092 --list

# create a topic that we'll configure
kafka-topics.sh --bootstrap-server localhost:9092 --create --topic configured-topic --partitions 3 --replication-factor 1

# look for existing configurations
kafka-topics.sh --bootstrap-server localhost:9092 --describe --topic configured-topic

# documentation of kafka-configs.sh command
kafka-configs.sh 

# Describe configs for the topic with the command
kafka-configs.sh --bootstrap-server localhost:9092 --entity-type topics --entity-name configured-topic --describe

# add a config to our topic
kafka-configs.sh --bootstrap-server localhost:9092 --entity-type topics --entity-name configured-topic --add-config min.insync.replicas=2 --alter

# Describe configs using kafka-configs
kafka-configs.sh --bootstrap-server localhost:9092 --entity-type topics --entity-name configured-topic --describe

# Describe configs using kafka-topics
kafka-topics.sh --bootstrap-server localhost:9092 --describe --topic configured-topic

# Delete a config
kafka-configs.sh --bootstrap-server localhost:9092 --entity-type topics --entity-name configured-topic --delete-config min.insync.replicas --alter

# ensure the config has been deleted
kafka-topics.sh --bootstrap-server localhost:9092 --describe --topic configured-topic

# Replace "kafka-consumer-groups" 
# by "kafka-consumer-groups.sh" or "kafka-consumer-groups.bat" based on your system # (or bin/kafka-consumer-groups.sh or bin\windows\kafka-consumer-groups.bat if you didn't setup PATH / Environment variables)

# look at the documentation again
kafka-consumer-groups

# reset the offsets to the beginning of each partition
kafka-consumer-groups.sh --bootstrap-server localhost:9092 --group my-first-application --reset-offsets --to-earliest

# execute flag is needed
kafka-consumer-groups.sh --bootstrap-server localhost:9092 --group my-first-application --reset-offsets --to-earliest --execute

# topic flag is also needed
kafka-consumer-groups.sh --bootstrap-server localhost:9092 --group my-first-application --reset-offsets --to-earliest --execute --topic first_topic

# consume from where the offsets have been reset
kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic first_topic --group my-first-application

# describe the group again
kafka-consumer-groups.sh --bootstrap-server localhost:9092 --describe --group my-first-application

# documentation for more options
kafka-consumer-groups.sh

# shift offsets by 2 (forward) as another strategy
kafka-consumer-groups.sh --bootstrap-server localhost:9092 --group my-first-application --reset-offsets --shift-by 2 --execute --topic first_topic

# shift offsets by 2 (backward) as another strategy
kafka-consumer-groups.sh --bootstrap-server localhost:9092 --group my-first-application --reset-offsets --shift-by -2 --execute --topic first_topic

# consume again
kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic first_topic --group my-first-application
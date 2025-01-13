##########Postgres Connector##################

curl -X POST http://localhost:8083/connectors \
-H "Content-Type: application/json" \
-d '{
  "name": "postgres-orders-source-connector",
  "config": {
    "connector.class": "io.confluent.connect.jdbc.JdbcSourceConnector",
    "connection.url": "jdbc:postgresql://postgres:5432/pokemondb",
    "connection.user": "leonardo",
    "connection.password": "leo123",
    "table.whitelist": "orders",
    "mode": "incrementing",
    "incrementing.column.name": "id",
    "topic.prefix": "postgres-",
    "poll.interval.ms": 1000,
    "key.converter": "org.apache.kafka.connect.json.JsonConverter",
    "value.converter": "org.apache.kafka.connect.json.JsonConverter",
    "key.converter.schemas.enable": false,
    "value.converter.schemas.enable": false
  }
}'

curl -X DELETE http://localhost:8083/connectors/postgres-pokemon-source-connector

##########Pokemon Postgres Connector####################
curl -X POST http://localhost:8083/connectors \
-H "Content-Type: application/json" \
-d '{
  "name": "postgres-pokemon-source-connector",
  "config": {
    "connector.class": "io.confluent.connect.jdbc.JdbcSourceConnector",
    "connection.url": "jdbc:postgresql://postgres:5432/pokemondb",
    "connection.user": "leonardo",
    "connection.password": "leo123",
    "table.whitelist": "pokemon",
    "mode": "incrementing",
    "incrementing.column.name": "id",
    "topic.prefix": "postgres-",
    "poll.interval.ms": 1000,
    "key.converter": "org.apache.kafka.connect.json.JsonConverter",
    "value.converter": "org.apache.kafka.connect.json.JsonConverter",
    "key.converter.schemas.enable": false,
    "value.converter.schemas.enable": false
  }
}'

###############Elasticsearch connector##############################


curl -X POST http://localhost:8083/connectors \
-H "Content-Type: application/json" \
-d ' {
  "name": "elasticsearch-sync-connector",
  "config": {
    "connector.class": "io.confluent.connect.elasticsearch.ElasticsearchSinkConnector",
    "connection.url": "http://elasticsearch:9200",
    "type.name": "_doc",
    "topics": "postgres-orders",
    "key.ignore": true,
    "schema.ignore": true,
    "value.converter": "org.apache.kafka.connect.json.JsonConverter",
    "value.converter.schemas.enable": false,
    "batch.size": 200,
    "flush.timeout.ms": 10000
  }
}'

#######Validate status###############

curl -X GET http://localhost:8083/connectors/elasticsearch-sync-connector/status
#################
./bin/kafka-console-consumer.sh \
  --bootstrap-server localhost:9092 \
  --topic postgres-orders-orders \
  --from-beginning


curl -X POST http://localhost:8083/connectors \
-H "Content-Type: application/json" \
-d '{
  "name": "postgres--source-connector",
  "config": {
    "connector.class": "io.confluent.connect.jdbc.JdbcSourceConnector",
    "connection.url": "jdbc:postgresql://postgres:5432/pokemondb",
    "connection.user": "leonardo",
    "connection.password": "leo123",
    "table.whitelist": "orders",
    "mode": "incrementing",
    "incrementing.column.name": "id",
    "topic.prefix": "postgres-",
    "poll.interval.ms": 1000,
    "key.converter": "org.apache.kafka.connect.json.JsonConverter",
    "value.converter": "org.apache.kafka.connect.json.JsonConverter"
  }
}'

curl -X PUT http://localhost:8083/connectors/postgres-source-connector/config \
-H "Content-Type: application/json" \
-d '{
  "connector.class": "io.confluent.connect.jdbc.JdbcSourceConnector",
  "connection.url": "jdbc:postgresql://postgres:5432/pokemondb",
  "connection.user": "leonardo",
  "connection.password": "leo123",
  "table.whitelist": "orders",
  "mode": "incrementing",
  "incrementing.column.name": "id",
  "topic.prefix": "postgres-orders-",
  "poll.interval.ms": 1000,
  "key.converter": "org.apache.kafka.connect.json.JsonConverter",
  "value.converter": "org.apache.kafka.connect.json.JsonConverter"
}'

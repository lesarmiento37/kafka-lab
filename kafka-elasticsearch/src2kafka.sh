curl -X POST http://localhost:8083/connectors \
-H "Content-Type: application/json" \
-d '{
  "name": "postgres-source-connector",
  "config": {
    "connector.class": "io.confluent.connect.jdbc.JdbcSourceConnector",
    "connection.url": "jdbc:postgresql://postgres:5432/pokemondb",
    "connection.user": "leonardo",
    "connection.password": "leo123",
    "mode": "incrementing",
    "incrementing.column.name": "id",
    "topic.prefix": "postgres-orders-",
    "poll.interval.ms": 1000
  }
}'

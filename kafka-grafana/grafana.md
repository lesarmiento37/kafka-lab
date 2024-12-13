# Kafka with Grafana and Prometheus Setup

This guide walks through the process of setting up Kafka integrated with Grafana and Prometheus for monitoring using Docker Compose.

---

## Prerequisites

- Docker installed on your system
- Docker Compose installed

---

## Overview

This setup includes:

1. **Kafka**: A message broker with a Zookeeper for coordination.
2. **Prometheus**: Collects metrics from Kafka via the JMX Exporter.
3. **Grafana**: Visualizes the metrics collected by Prometheus.

---

## Step 1: Docker Compose File

Create a `docker-compose.yml` file with the following content:

```yaml
docker-compose.yml
version: '3.8'
services:
  zookeeper:
    image: confluentinc/cp-zookeeper:7.3.0
    container_name: zookeeper
    environment:
      ZOOKEEPER_CLIENT_PORT: 2181
      ZOOKEEPER_TICK_TIME: 2000
    ports:
      - "2181:2181"

  kafka:
    image: confluentinc/cp-kafka:7.3.0
    container_name: kafka
    depends_on:
      - zookeeper
    ports:
      - "9092:9092"
    environment:
      KAFKA_BROKER_ID: 1
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://localhost:9092
      KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1
      KAFKA_JMX_PORT: 9999
      KAFKA_JMX_HOSTNAME: kafka
    volumes:
      - ./kafka-metrics:/opt/kafka/config

  jmx-exporter:
    image: bitnami/jmx-exporter:0.17.2
    container_name: jmx-exporter
    ports:
      - "8080:8080"
    environment:
      JMX_PORT: 9999
    depends_on:
      - kafka
    command:
      - --config.file=/opt/jmx-exporter/config.yml
    volumes:
      - ./jmx-config.yml:/opt/jmx-exporter/config.yml

  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_USER=admin
      - GF_SECURITY_ADMIN_PASSWORD=admin
    volumes:
      - grafana-data:/var/lib/grafana

volumes:
  grafana-data:
```

---

## Step 2: Configuration Files

### Prometheus Configuration

Create a `prometheus.yml` file:

```yaml
# prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'kafka'
    static_configs:
      - targets: ['jmx-exporter:8080']
```

### JMX Exporter Configuration

Create a `jmx-config.yml` file:

```yaml
# jmx-config.yml
rules:
  - pattern: "kafka.server<type=(.+), name=(.+)><>(.+)"
    name: "kafka_server_$1_$2_$3"
    type: GAUGE
    labels:
      metric: "$1_$2"
      topic: "$3"
```

---

## Step 3: Start the Containers

Run the following command to start the services:

```bash
docker-compose up -d
```

---

## Step 4: Access the Services

1. **Kafka Broker**: `localhost:9092`
2. **Prometheus**: `http://localhost:9090`
3. **Grafana**: `http://localhost:3000` (default credentials: `admin/admin`)

---

## Step 5: Integrate Grafana with Prometheus

1. Log into Grafana at `http://localhost:3000`.
2. Add Prometheus as a data source:
   - Navigate to **Configuration** > **Data Sources**.
   - Select **Prometheus**.
   - Enter the URL: `http://prometheus:9090`.
3. Import Kafka dashboards or create custom ones:
   - You can find Kafka dashboards on [Grafana's website](https://grafana.com/grafana/dashboards/).

---

## Conclusion

This setup provides:

- Kafka metrics monitoring with Prometheus.
- Kafka metrics visualization using Grafana.

You can extend the setup to include more services or customize the dashboards as per your requirements.

## Results
![image](https://github.com/user-attachments/assets/a5203d36-9f06-433b-8128-c2e686d69061)

# **Monitoring Kafka with Metricbeat, Elasticsearch, and Kibana**

## **Overview**

This guide outlines the step-by-step process for monitoring Kafka metrics using Metricbeat, Elasticsearch, and Kibana. The visualization in Kibana displays Kafka broker memory usage metrics, alongside other metrics collected from the environment.

---

## **Procedure**

### **1. Set Up the Environment**

Begin by setting up a local environment that includes Elasticsearch, Kibana, Kafka, Zookeeper, and Metricbeat. These components are interconnected to enable monitoring of Kafka metrics.

1. **Elasticsearch**: Acts as the datastore for all metrics collected by Metricbeat.
2. **Kibana**: Used to visualize the metrics stored in Elasticsearch.
3. **Kafka**: A distributed messaging system to monitor.
4. **Zookeeper**: Provides coordination for Kafka.
5. **Metricbeat**: Collects metrics from Kafka and sends them to Elasticsearch.

---

### **2. Configure Metricbeat**

- Enable the Kafka module in Metricbeat to collect metrics such as partition, broker memory usage, and consumer group activity.
- Configure the Metricbeat output to send data to Elasticsearch. Ensure Metricbeat is correctly pointing to the Elasticsearch and Kafka endpoints.

---

### **3. Deploy the Monitoring Stack**

- Start all components in the stack, including Elasticsearch, Kibana, Kafka, Zookeeper, and Metricbeat.
- Ensure that each service is running and communicating with the others.

---

### **4. Generate Kafka Metrics**

To simulate activity in Kafka:
- Create topics in Kafka.
- Produce and consume messages on these topics to generate metrics for monitoring.

---

### **5. Verify Data Collection**

- Confirm that Metricbeat is successfully collecting Kafka metrics and sending them to Elasticsearch.
- Use tools like logs or API endpoints to verify that the data pipeline is operational.

---

### **6. Access Kibana**

- Open Kibana in a web browser.
- Navigate to the "Discover" section to view the collected data from Metricbeat.
- Verify that the data matches the Kafka activity generated in the earlier steps.

---

### **7. Explore Kafka Metrics in Kibana**

- Use the preconfigured Metricbeat dashboards for Kafka, or create custom visualizations.
- Analyze metrics such as broker memory usage, consumer group offsets, and partition status.
- Review the visualization showing memory usage metrics over time, as depicted in the provided Kibana screenshot.

---

## **Kibana Visualization**

![Kibana Visualization](attachment:file-7EaLqGGC2zZDUvNaKw2SqV)

The visualization in Kibana illustrates:
- Kafka broker memory usage over time, aggregated at intervals.
- A document view of individual data points, including detailed metrics like `activemq.broker.memory.temp.pct`.
- The time filter at the top right allows analysis of specific time ranges, helping to identify patterns or anomalies.

---

### **8. Troubleshooting**

- If no data is visible in Kibana:
  - Verify Metricbeat logs to ensure it is collecting and sending data.
  - Confirm connectivity between Metricbeat and Kafka.
  - Check that the Elasticsearch and Kibana services are running without errors.
- Ensure proper permissions are set for Metricbeat’s configuration file.

---
### **9. Results**
After following the procedure of installation the terminal shows the docker containers:

![image](https://github.com/user-attachments/assets/71cb5cf2-4586-472e-8c4c-cee384803525)

And this dashboard:

![image](https://github.com/user-attachments/assets/f696241f-33c1-4a54-b110-b139b05cbd1c)


## **Conclusion**

You can now monitor Kafka metrics effectively using Metricbeat, Elasticsearch, and Kibana. The setup provides real-time insights into Kafka's health and performance, helping to identify and address potential issues proactively.






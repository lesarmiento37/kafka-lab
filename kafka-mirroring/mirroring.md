# MirrorMaker 2 Configuration Exercise

This documentation provides an overview and instructions for completing the MirrorMaker 2 configuration exercise as outlined in the [Confluent Hybrid Cloud Course](https://developer.confluent.io/courses/hybrid-cloud/mirrormaker2-configuration-exercise/).

## Overview

MirrorMaker 2 is a tool included with Apache Kafka that enables replication and synchronization of Kafka clusters. It is commonly used to:

- Migrate topics and data between clusters.
- Set up a hybrid or multi-cloud Kafka architecture.
- Provide disaster recovery and high availability for Kafka clusters.

In this exercise, you will learn how to configure and run MirrorMaker 2 to replicate topics from one Kafka cluster to another. By the end of the exercise, you should understand the necessary configuration parameters, how to verify data replication, and troubleshoot common issues.

## Prerequisites

Before starting this exercise, ensure you have the following:

1. **Kafka and Confluent Platform Installed:**  
   Make sure you have Kafka and the Confluent Platform installed and running on the environments where replication will occur.
   
2. **Two Kafka Clusters:**  
   You will need access to at least two distinct Kafka clusters (source and target). These clusters could be:
   - Two local clusters on different ports.
   - A combination of on-prem and cloud-based clusters.
   - Two cloud-based clusters in different regions or providers.
   
3. **Kafka Topics and Messages:**  
   The source cluster should have at least one topic populated with data to replicate.

4. **Basic Kafka Command-Line Knowledge:**  
   Familiarity with `kafka-topics` and `kafka-console-consumer` commands is helpful for verifying the replication process.

## Key Concepts

- **Source and Target Clusters:**  
  MirrorMaker 2 uses a configuration to point from a source cluster (where your messages currently live) to a target cluster (where you want to replicate them).

- **Connectors and Worker Properties:**  
  MirrorMaker 2 is built on Kafka Connect, so it relies on a worker configuration file and connector configurations. You will define:
  - **Worker Properties (`connect-distributed.properties`):** Defines how the Kafka Connect cluster runs, including bootstrap server addresses, key and value converters, and internal topics.
  - **MirrorMaker 2 Connectors (`mm2-*.json`):** Specifies the source and target clusters, replication policies, and any topic filtering or renaming rules.

- **Replication Policy:**  
  You can use custom replication policies to manage how topics are named in the target cluster. By default, MirrorMaker 2 might prefix replicated topics with the name of the source cluster.

- **Monitoring and Verification:**  
  After starting MirrorMaker 2, verify replication by:
  - Listing topics on the target cluster.
  - Consuming messages from the replicated topic in the target cluster.
  - Checking logs and metrics exposed by the Kafka Connect worker.

## Steps to Complete the Exercise

1. **Set Up Your Source and Target Clusters:**
   - Ensure both clusters are running.
   - Confirm that the source cluster has the topic(s) and messages you want to replicate.

2. **Prepare MirrorMaker 2 Configuration:**
   - Create or modify a Kafka Connect worker property file (e.g., `connect-distributed.properties`).
   - Create a MirrorMaker 2 connector configuration file (e.g., `mm2-connector.json`) that details source and target bootstrap servers, replication policies, and topics to include.

3. **Start the Kafka Connect Worker:**
   - Run the Kafka Connect distributed mode process with your worker properties.
   - Check the logs to ensure the worker starts successfully without errors.

4. **Deploy the MirrorMaker 2 Connector:**
   - Use the Kafka Connect REST API to post your `mm2-connector.json` configuration.
   - Confirm that the connector transitions to a `RUNNING` state.

5. **Verify Replication:**
   - Run `kafka-topics` against the target cluster to see if the expected topics have appeared.
   - Use `kafka-console-consumer` against the replicated topic on the target cluster to ensure messages are flowing as expected.

6. **Troubleshoot if Needed:**
   - Check worker and connector logs for errors.
   - Verify network connectivity between source and target clusters.
   - Confirm that topic filters and replication policies are set correctly.
7. **Results:**
After deploying the kafka ehis is the output:

Create replicate_me Topic:
![image](https://github.com/user-attachments/assets/980925d1-f69a-40e4-bb7e-31d9a5c05448)

Produce Random data to the new Topic:
![image](https://github.com/user-attachments/assets/06e4e0a4-e208-457f-920c-ba5176e7b7c7)

Create And Check the connector.json file (attached in this repo)
![image](https://github.com/user-attachments/assets/98ae9ff0-a02d-4d80-bbdf-ca0de253213d)

![image](https://github.com/user-attachments/assets/986c8b9d-8c65-47e0-83d6-26614f7270ee)

![image](https://github.com/user-attachments/assets/85f0d074-25d3-4d2f-9848-7909138b3e49)

![image](https://github.com/user-attachments/assets/47a53504-f05d-4686-87c3-101e05571d67)

## Tips and Best Practices

- **Keep Configurations Organized:**  
  Store your worker and connector configuration files in a version-controlled repository for easy maintenance and auditing.

- **Use Metrics and Monitoring:**  
  Leverage Kafka Connect’s built-in metrics and logging. Metrics can give insights into throughput, lag, and errors during replication.

- **Iterative Approach:**  
  Start with a small subset of topics to replicate. Once validated, gradually add more topics and complexity.

## Additional Resources

- [Official Apache Kafka Documentation](https://kafka.apache.org/documentation/)
- [Confluent Kafka Connect Documentation](https://docs.confluent.io/home/connect/overview.html)
- [Confluent Hybrid Cloud Course](https://developer.confluent.io/courses/hybrid-cloud/)

---

By following this guide, you will configure and run MirrorMaker 2 to replicate data between Kafka clusters, an essential skill for hybrid and multi-cloud Kafka deployments.





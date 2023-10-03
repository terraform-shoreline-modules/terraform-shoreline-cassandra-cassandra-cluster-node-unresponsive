
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Cassandra cluster Node unresponsive and resulting data unavailability.
---

This incident type involves the detection of an unresponsive node in a Cassandra cluster, which can result in data unavailability and potential disruptions to services. The cause of the issue may vary, but it can be related to factors such as hardware failure or network problems. It is important to address such incidents quickly to minimize any negative impact on the affected services and ensure data availability.

### Parameters
```shell
export NODE_IP="PLACEHOLDER"

export KEYSPACE="PLACEHOLDER"

export OTHER_NODE_IP="PLACEHOLDER"

export NODEA="PLACEHOLDER"

export CPU_OR_MEMORY="PLACEHOLDER"

```

## Debug

### Check the connection to node a by pinging its ip address.
```shell
ping ${NODE_IP}
```

### Check if Cassandra service is running on Node
```shell
 systemctl status cassandra
```

### Check Cassandra logs for any errors related to Node 
```shell
 tail -n 100 /var/log/cassandra/system.log | grep ${NODE_IP}
```

### Check network connectivity between Node A and other nodes in the cluster
```shell
 nodetool status | grep UN
```

### Check if there are any hardware issues on Node A
```shell
 ipmitool sel list
```

### Check if there are any pending repairs or compactions for the affected keyspace
```shell
 nodetool tpstats | grep repair

 nodetool compactionstats | grep ${KEYSPACE}
```

### Check if there are any disk space issues on Node A
```shell
 df -h
```


### Check if there are any network issues between Node A and other nodes in the cluster
```shell
traceroute ${OTHER_NODE_IP}
```

### Check if there are any firewall rules blocking traffic to Node A
```shell
 systemctl status firewalld
```

### Resource exhaustion on Node (e.g. CPU, memory)
```shell


#!/bin/bash



# Set the target node and resource type

NODE=${NODE}

RESOURCE=${CPU_OR_MEMORY}



# Check the current resource usage on the node

echo "Checking $RESOURCE usage on $NODE..."

ssh $NODE "top -b -n 1 | grep $RESOURCE"



# Check the system logs for any related errors or warnings

echo "Checking system logs on $NODE..."

ssh $NODE "cat /var/log/syslog | grep -i $RESOURCE"



# Check the Cassandra logs for any related errors or warnings

echo "Checking Cassandra logs on $NODE..."

ssh $NODE "cat /var/log/cassandra/system.log | grep -i $RESOURCE"



# Check the network connectivity between the node and other cluster nodes

echo "Checking network connectivity on $NODE..."

ssh $NODE "ping ${OTHER_NODE}"



# Check the Cassandra cluster status and node health

echo "Checking Cassandra cluster status on $NODE..."

ssh $NODE "nodetool status"

ssh $NODE "nodetool describecluster"



# Perform any necessary diagnostics or remediation steps based on the findings


```

## Repair

### Restart the unresponsive Node  and see if it rejoins the cluster. If it does, monitor it closely for any future issues.
```shell


#!/bin/bash



# Define the variables

NODE=${NODE}



# Restart the node

sudo service cassandra restart $NODE



# Monitor the node for any future issues

# You can use a tool like Nagios, Zabbix, or Datadog to monitor the node

# Alternatively, you can just use the "nodetool status" command to check the node's status


```
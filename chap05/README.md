# Chapter 5 - Network and Security

* In this section, we will focus on:
  * Docker networking
  * K8s networking
  * Ingress
  * Network Policy

## Table of content
- [1. K8s networking](#1-k8s-networking)
  - [1.1. Docker networking](#11-docker-networking)

## Annotation
|No.|Term|Description|
|-|-|-|
|1|Ethernet|Ethernet is a family of networking technologies used to transmit data over a local area network (LAN)|
|2|Network namespace|Network namespace is a feature of Linux, it has its own **routing tables $^{3}$**, **arp tables $^{4}$**, and network devices.|
|3| Routing tables|A routing table is a database maintained by a router that lists the available routes to destination networks or hosts. The routing table contains information that a router uses to determine the best path for forwarding IP packets to their destination.|
|4|ARP tables|An Address Resolution Protocol (ARP) table is a table maintained by a device on a local area network (LAN) that maps IP addresses to Media Access Control (MAC) addresses. The ARP protocol is used to translate IP addresses to MAC addresses, which are used to identify network devices at the data link layer of the OSI model.|

## 1. K8s networking
* K8s itself does not care how you implement networking in your cluster, but you must meet its three requirements:
  * All containers should be accessible to each other without NAT, regardless of which nodes they are on.
  * All nodes should communicate with all containers.
  * The IP container should see itself the same way as the others see it.

### 1.1. Docker networking
* There are three modes of container networking in Docker:
  * Bridge mode
  * Host mode
  * None mode

* **Bridge** is the default networking model. Docker creates and attaches virtual __Ethernet $^{1}$__ device (also know as `veth`) and assigns **network namespace $^{2}$** to each container.


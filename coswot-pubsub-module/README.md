# Publisher-Subscriber Communication System in C

This project implements a **Publisher-Subscriber (Pub/Sub)** communication system in the C programming language. The system enables real-time data transfer using **TCP sockets** and models sensor data using **RDF triples**. It is particularly designed for IoT scenarios where sensors produce structured observations that need to be selectively forwarded to interested clients.

---

## Project Scope

This repository is part of a larger academic project titled **COSWOT: Communication Between Publisher and Subscriber**.  
While the overall COSWOT system includes pre-provided libraries and modules (such as RDF handling, ontology definitions, and data structures), **this repository contains only the communication module** that was implemented from scratch.  
It specifically covers the **Publisher-Subscriber architecture**, including topic-based subscriptions, TCP socket communication, and RDF triple transmission.

---

## Project Info

- **Project Name:** COSWOT: Communication Between Publisher and Subscriber
- **Language:** C
- **Main File:** `publisher_subscriber_module.c`  
- **Author:** Betul Aslan - Melis Karadag

---

## Academic Info

- **Course:** Research Project  
- **Institution:** INSA Lyon  
- **Department:** Computer Science  
- **Academic Year:** 2024–2025 Fall
- **Assignment:** Term Project

---

## Topics Covered

- Publisher-Subscriber pattern over TCP  
- Multi-threaded connection handling in C  
- Socket programming using `AF_INET` and `SOCK_STREAM`  
- Linked list data structure for managing subscribers  
- RDF (Resource Description Framework) data modeling  
- Custom ontologies (`coswot:Observation`)  
- RDF triple serialization using `urdflib`  

---

## How It Works

### System Architecture

- The system includes a **Publisher** and multiple **Subscribers**.
- The **Publisher** listens for connections and sends RDF-formatted data to matching subscribers.
- Subscribers connect and subscribe to specific **topics** like `temperature`, `humidity`, or individual `Sensor_1` to `Sensor_6`.
- Topics are handled semantically, with RDF data built using defined predicates such as `coswot:madeBy` and `coswot:hasResult`.

### Execution Modes

- **Publisher Mode:**
- **Subscriber Mode:**

---

## Code Features and Usage

- **Threads:** Each subscriber connection is managed in a separate thread using `pthread_create`.  
- **Data Simulation:** A thread periodically generates simulated RDF observations every 5 seconds.  
- **Linked List:** Subscribers are stored in a dynamically managed linked list.  
- **RDF Graph:** Sensor data is structured as RDF triples using `urdflib.h` and an ontology in `Ontology.h`.  
- **Topic Filtering:** Only matching subscribers (by topic or sensor ID) receive the RDF packets.  
- **Mutexes:** Synchronization is maintained with `pthread_mutex_lock` to protect shared RDF data.

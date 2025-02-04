#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <pthread.h>
#include <time.h>
#include "modules.h"
#include "urdflib.h"
#include "Ontology.h"
#include "collection/LinkedListGeneric.h"

#define BUFFER_SIZE_2 4096
#define MAX_SUBSCRIBERS 10
#define SENSOR_COUNT 6

// Struct for storing the current data
typedef struct {
    char type[50];
    int sensor_id;
    urdflib_t graph;
    char source[50];
    char timestamp[50];
} SensorData;

// Struct for subscriber info
typedef struct Subscriber {
    int client_fd;   
    char topic[50];
    char client_ip[INET_ADDRSTRLEN];   
    int client_port;
    struct Subscriber *next;   
} Subscriber;

// Global variables
pthread_mutex_t data_lock;
SensorData current_data;
Subscriber *subscriber_list = NULL;

// Functions
int init_module_pubsub(int argc, char *argv[]);
void *sensor_data_generator(void *arg);
void handle_publisher(int listen_port);
void *handle_subscriber(void *arg);
void handle_subscriber_with_topic(const char *server_ip, int server_port, const char *topic);
urdflib_t generate_random_data(const char *type, int sensor_id);
void add_subscriber(Subscriber **head, int client_fd, const char *topic, const char *client_ip, int client_port);
void print_subscribers(Subscriber *head);
void free_subscribers(Subscriber **head);

// Function to add a subscriber to the linked list
void add_subscriber(Subscriber **head, int client_fd, const char *topic, const char *client_ip, int client_port) {
    Subscriber *new_subscriber = (Subscriber *)malloc(sizeof(Subscriber));
    if (new_subscriber == NULL) {
        perror("Failed to allocate memory for new subscriber");
        return;
    }
    new_subscriber->client_fd = client_fd;
    strncpy(new_subscriber->topic, topic, sizeof(new_subscriber->topic));
    strncpy(new_subscriber->client_ip, client_ip, sizeof(new_subscriber->client_ip));
    new_subscriber->client_port = client_port;
    new_subscriber->next = *head;
    *head = new_subscriber;
}

// Function to print all subscribers
void print_subscribers(Subscriber *head) {
    printf("Current Subscribers:\n");
    Subscriber *current = head;
    while (current != NULL) {
        printf("IP: %s, Port: %d, Topic: %s\n", current->client_ip, current->client_port, current->topic);
        current = current->next;
    }
}

void free_subscribers(Subscriber **head) {
    Subscriber *current = *head;
    while (current != NULL) {
        Subscriber *next = current->next;
        free(current);
        current = next;
    }
    *head = NULL;
}

// Function to get the current timestamp
void get_current_timestamp(char *buffer, size_t buffer_size) {
    time_t now = time(NULL);
    struct tm *tm_info = localtime(&now);
    strftime(buffer, buffer_size, "%Y-%m-%d %H:%M:%S", tm_info);
}

// Function to initialize the publisher-subscriber module
int init_module_pubsub(int argc, char *argv[]) {
    pthread_mutex_init(&data_lock, NULL);
    current_data.graph = urdflib_create_graph();
    strcpy(current_data.type, "");
    current_data.sensor_id = 0;

    if (argc >= 3) {
        const char *mode = argv[1];
        if (strcmp(mode, "p") == 0) {
            if (argc != 3) {
                fprintf(stderr, "Usage for publisher: init_module_pubsub p <port>\n");
                return -1;
            }
            int port = atoi(argv[2]);
            pthread_t sensor_thread_id;
            pthread_create(&sensor_thread_id, NULL, sensor_data_generator, NULL);
            handle_publisher(port);
            pthread_cancel(sensor_thread_id);
            pthread_join(sensor_thread_id, NULL);
        } 
        else if (strcmp(mode, "s") == 0) {
            if (argc != 5) {
                fprintf(stderr, "Usage for subscriber: init_module_pubsub s <ip> <port> <topic>\n");
                return -1;
            }
    
            const char *server_ip = argv[2];
            int server_port = atoi(argv[3]);
            const char *topic = argv[4];
            handle_subscriber_with_topic(server_ip, server_port, topic);
        } 
        else {
            fprintf(stderr, "Invalid mode. Use 'p' for publisher or 's' for subscriber.\n");
            return -1;
        }
    } 
    else printf("[INIT] init_module_pubsub called without execution arguments. Default initialization.\n");
    
    free_subscribers(&subscriber_list);
    return 0;
}

// Function to create random observation data in RDF format
urdflib_t generate_random_data(const char *type, int sensor_id) {
    urdflib_t graph = urdflib_create_graph();  
    
    //subject
    int obs_id=0;
    urdflib_t observation = urdflib_create_uriref_curie(1, obs_id); 
    urdflib_t received_data_type = urdflib_create_literal("Observation");

    //source object
    char source_value[30];
    snprintf(source_value, sizeof(source_value), "Sensor_%d", sensor_id);
    urdflib_t source_object = urdflib_create_literal(source_value); 

    //result value object
    char value[10];
    snprintf(value, sizeof(value), "%d", (rand() % 100) + 1); 
    urdflib_t result_object = urdflib_create_literal(value); 

    //type object
    urdflib_t type_object = urdflib_create_literal(type);

    //observation time object
    char timestamp[50];
    get_current_timestamp(timestamp, sizeof(timestamp)); 
    urdflib_t time_object = urdflib_create_literal(timestamp); 

    //adding triples to the graph
    urdflib_add_triple(&graph, &observation, &Ontology.rdf.type, &Ontology.coswot.Observation); 
    urdflib_add_triple(&graph, &observation, &Ontology.coswot.madeBy, &source_object);
    urdflib_add_triple(&graph, &observation, &Ontology.coswot.hasResult, &result_object); 
    urdflib_add_triple(&graph, &observation, &Ontology.coswot.hasResultType, &type_object);
    urdflib_add_triple(&graph, &observation, &Ontology.coswot.hasResultTime, &time_object);

    urdflib_freeze(&graph);

    //printing generated triples for control
    printf("Generated RDF Data:\n");
    urdflib_ctx_t ctx = {0};
    urdflib_t s, p, o;

    while (urdflib_find_next_triple(&graph, &ctx, &s, &p, &o) == STATUS_OK) {
        printf("Subject: ");
        urdflib_print(&s);
        printf("Predicate: ");
        urdflib_print(&p);
        printf("Object: ");
        urdflib_print(&o);
        printf("\n");
    }

    obs_id++;
    return graph;
}

void *sensor_data_generator(void *arg) {
    while (1) {
        int sensor_id = rand() % SENSOR_COUNT + 1;
        const char *type;

        if (sensor_id <= 3) type = "temperature";
        else if (sensor_id <= SENSOR_COUNT) type = "humidity";
    
        pthread_mutex_lock(&data_lock);
        current_data.graph = generate_random_data(type, sensor_id);
        strncpy(current_data.type, type, sizeof(current_data.type));
        current_data.sensor_id = sensor_id;
        get_current_timestamp(current_data.timestamp, sizeof(current_data.timestamp));
        pthread_mutex_unlock(&data_lock); 

        printf("Generated data for sensor %d of type %s at %s.\n", sensor_id, type, current_data.timestamp);

        sleep(5); 
    }
    return NULL;
}

void handle_publisher(int listen_port) {
    int server_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (server_fd < 0) {
        perror("Socket creation failed.");
        exit(EXIT_FAILURE);
    }

    struct sockaddr_in server_address = {0};
    server_address.sin_family = AF_INET;
    server_address.sin_port = htons(listen_port);
    server_address.sin_addr.s_addr = INADDR_ANY;

    if (bind(server_fd, (struct sockaddr *)&server_address, sizeof(server_address)) < 0) {
        perror("Bind failed.");
        close(server_fd);
        exit(EXIT_FAILURE);
    }

    if (listen(server_fd, 5) < 0) {
        perror("Listen failed.");
        close(server_fd);
        exit(EXIT_FAILURE);
    }

    printf("Publisher listening on port %d\n", listen_port);

    while (1) {
        struct sockaddr_in client_address;
        socklen_t client_len = sizeof(client_address);
        int client_fd = accept(server_fd, (struct sockaddr *)&client_address, &client_len);
        if (client_fd < 0) {
            perror("Accept failed");
            continue;
        }

        char client_ip[INET_ADDRSTRLEN];
        inet_ntop(AF_INET, &client_address.sin_addr, client_ip, INET_ADDRSTRLEN);
        int client_port = ntohs(client_address.sin_port);

        printf("Connection from %s:%d\n", client_ip, client_port);

        pthread_t subscriber_thread;
        Subscriber *new_subscriber = (Subscriber *)malloc(sizeof(Subscriber));
        if (new_subscriber == NULL) {
            perror("Failed to allocate memory for new subscriber.");
            close(client_fd);
            continue;
        }

        new_subscriber->client_fd = client_fd;
        strncpy(new_subscriber->client_ip, client_ip, sizeof(new_subscriber->client_ip));
        new_subscriber->client_port = client_port;
        new_subscriber->next = NULL;

        pthread_create(&subscriber_thread, NULL, handle_subscriber, (void *)new_subscriber);
        pthread_detach(subscriber_thread);
    }
    close(server_fd);
}

void *handle_subscriber(void *arg) {
    Subscriber *subscriber = (Subscriber *)arg;
    int client_fd = subscriber->client_fd;

    char subscription_request[BUFFER_SIZE_2];
    int received_bytes = recv(client_fd, subscription_request, BUFFER_SIZE_2, 0);
    if (received_bytes <= 0) {
        perror("Receive failed.");
        close(client_fd);
        free(subscriber);
        pthread_exit(NULL);
    }
    subscription_request[received_bytes] = '\0';
    strncpy(subscriber->topic, subscription_request, sizeof(subscriber->topic));

    printf("Subscriber requested topic: %s\n", subscription_request);

    int is_valid_topic = 0;
    int sensor_id = -1;

    if (strncmp(subscription_request, "temperature", 11) == 0 || strncmp(subscription_request, "humidity", 8) == 0) is_valid_topic = 1;
    else if (strncmp(subscription_request, "Sensor_", 7) == 0) {
        sensor_id = atoi(subscription_request + 7);
        if (sensor_id >= 1 && sensor_id <= 6) is_valid_topic = 1;
        else printf("Invalid sensor ID in topic: %s. Connection rejected.\n", subscription_request);
    } 
    else printf("Invalid topic requested: %s. Connection rejected.\n", subscription_request);
    
    if (!is_valid_topic) {
        close(client_fd);
        free(subscriber);
        pthread_exit(NULL);
    }

    pthread_mutex_lock(&data_lock);
    add_subscriber(&subscriber_list, client_fd, subscription_request, subscriber->client_ip, subscriber->client_port);
    print_subscribers(subscriber_list);
    pthread_mutex_unlock(&data_lock);

    while (1) {
        pthread_mutex_lock(&data_lock);
        if (strcmp(subscriber->topic, current_data.type) == 0 || (strncmp(subscriber->topic, "Sensor_", 7) == 0 && atoi(subscriber->topic + 7) == current_data.sensor_id)) {
            if (send(client_fd, current_data.graph.buffer, current_data.graph.size, 0) < 0) {
                perror("Send failed");
                pthread_mutex_unlock(&data_lock);
                break;
            }
        }
        pthread_mutex_unlock(&data_lock);
        sleep(5);
    }

    close(client_fd);
    free(subscriber);
    pthread_exit(NULL);
}

void handle_subscriber_with_topic(const char *server_ip, int server_port, const char *topic) {
    int sock_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (sock_fd < 0) {
        perror("Socket creation failed.");
        exit(EXIT_FAILURE);
    }

    struct sockaddr_in server_address = {0};
    server_address.sin_family = AF_INET;
    server_address.sin_port = htons(server_port);

    if (inet_pton(AF_INET, server_ip, &server_address.sin_addr) <= 0) {
        perror("Invalid IP address format.");
        close(sock_fd);
        exit(EXIT_FAILURE);
    }

    if (connect(sock_fd, (struct sockaddr *)&server_address, sizeof(server_address)) < 0) {
        perror("Connection failed.");
        close(sock_fd);
        exit(EXIT_FAILURE);
    }

    printf("Connected to publisher at %s:%d\n", server_ip, server_port);

    if (send(sock_fd, topic, strlen(topic), 0) < 0) {
        perror("Send subscription request failed.");
        close(sock_fd);
        exit(EXIT_FAILURE);
    }
                    
    int valid_sensor_ids[] = {1, 2, 3, 4, 5, 6};
    int is_valid_sensor = 0;
    int sensor_id = 0;

    if (strncmp(topic, "Sensor_", 7) == 0) {
        sensor_id = atoi(topic + 7);
        for (int i = 0; i < sizeof(valid_sensor_ids) / sizeof(valid_sensor_ids[0]); i++) {
            if (sensor_id == valid_sensor_ids[i]) {
                is_valid_sensor = 1;
                break;
                            
            }
        }
    }

    int is_valid_type = (strcmp(topic, "temperature") == 0 || strcmp(topic, "humidity") == 0);

    if (!is_valid_sensor && !is_valid_type) {
        char error_message[] = "Error: Invalid topic. Please use 'temperature', 'humidity', or 'Sensor_<1-6>'.\n";
        printf("%s",error_message);
        exit(EXIT_FAILURE);
    }

    printf("Sent subscription request for: %s\n", topic);

    char buffer[BUFFER_SIZE_2];
    urdflib_t received_graph;

    while (1) {
        int received_bytes = recv(sock_fd, buffer, BUFFER_SIZE_2, 0);
        if (received_bytes > 0) {
            received_graph.buffer = (uint8_t *)buffer;
            received_graph.size = received_bytes;
            received_graph.type = TYPE_GRAPH;

            printf("\nReceived RDF Data:\n");

            urdflib_ctx_t ctx = {0};
            urdflib_t s, p, o;

            int observation_found = 0; 
            urdflib_t observation_id;
            char ont_area[50]; 

            //checking if the received data is Observation (rdf:type Observation)
            urdflib_ctx_t type_check_ctx = ctx;
            while (urdflib_find_next_triple(&received_graph, &type_check_ctx, &s, &p, &o) == STATUS_OK) {
                if (urdflib_eq(&p, &Ontology.rdf.type) && urdflib_eq(&o, &Ontology.coswot.Observation)) {
                    observation_found = 1;
                    observation_id = s;
                    strcpy(ont_area, "coswot"); 
                    break;
                }
            }

            if (!observation_found) {
                printf("No Observation found in RDF data.\n");
                return;
            }

            char subject_str[50]="";
            char predicate_str[50]="";
            char object_str[50]="";

            //process the triples for the observation
            while (urdflib_find_next_triple(&received_graph, &ctx, &s, &p, &o) == STATUS_OK) {

                if (!urdflib_eq(&s, &observation_id)) continue;
            
                if (urdflib_eq(&p, &Ontology.rdf.type)) {
                    snprintf(subject_str, sizeof(subject_str), "Observation");
                    snprintf(predicate_str, sizeof(predicate_str), "rdf:type");

                    if (urdflib_eq(&o, &Ontology.coswot.Observation)) snprintf(object_str, sizeof(object_str), "coswot:Observation");
                    else urdflib_print(&o);
        
                    printf("%s %s %s\n", subject_str, predicate_str, object_str);
                    continue;
                }

                if (urdflib_eq(&p, &Ontology.coswot.hasResultType)) snprintf(predicate_str, sizeof(predicate_str), "%s:hasResultType", ont_area);
                else if (urdflib_eq(&p, &Ontology.coswot.madeBy)) snprintf(predicate_str, sizeof(predicate_str), "%s:madeBy", ont_area);
                else if (urdflib_eq(&p, &Ontology.coswot.hasResultTime)) snprintf(predicate_str, sizeof(predicate_str), "%s:hasTime", ont_area);
                else if (urdflib_eq(&p, &Ontology.coswot.hasResult)) snprintf(predicate_str, sizeof(predicate_str), "%s:hasResult", ont_area);
                else urdflib_print(&p);
        
                if (urdflib_is_literal(&o)) {
                    char *value_str;
                    size_t value_len;

                    if (urdflib_get_lexical_value(&o, &value_str, &value_len) == STATUS_OK) snprintf(object_str, sizeof(object_str), "%.*s", (int)value_len, value_str);
                    else strcpy(object_str, "[Error retrieving value]");
        
                } 
                else urdflib_print(&o);

                printf("%s %s %s\n", subject_str, predicate_str, object_str);
            }
        } 
        else if (received_bytes == 0) {
            printf("Connection closed by publisher\n");
            break;
        } 
        else {
            perror("Receive failed");
            break;
        }
    }
    close(sock_fd);
}

int exec_module_pubsub(int argc, char *argv[]) {
    return EXIT_SUCCESS;
}

int free_module_pubsub() {
    urdflib_delete(&current_data.graph);
    pthread_mutex_destroy(&data_lock);
    free_subscribers(&subscriber_list);
    return 0;
}
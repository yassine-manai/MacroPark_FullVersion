import json
import paho.mqtt.client as mqtt
from Config.config import *

broker_address = brocker_server 
broker_port = brocker_port
topic_pub = brocker_topic_pub

client = mqtt.Client()


def connect_to_broker():
    client.connect(broker_address, broker_port)
    client.loop_start()

def disconnect_from_broker():
    client.loop_stop()
    client.disconnect()




def publish_to_mqtt_broker(data: dict):
    json_data = json.dumps(data)
    
    client.connect(broker_address, broker_port)
    print(f"Connected to MQTT : {broker_address}")
    
    client.publish(topic_pub, json_data)  
    print(f"Published Topic : {topic_pub}")
    print(f"Published message : {json_data}")

    client.disconnect()

    return {
        "mqtt_server": broker_address,
        "mqtt_topic_pub": topic_pub
    }


















""" def on_connect(client, userdata, flags, rc):
    if rc == 0:
        print("Connected to MQTT broker")
        # Subscribe to the topic upon successful connection
        subscribe_topic(topic_sub)
    else:
        print(f"Connection failed with code {rc}")

def on_disconnect(client, userdata, rc):
    print("Disconnected from MQTT broker")

def on_message(client, userdata, message):
    print(f"Received message '{message.payload.decode()}' on topic '{message.topic}'")
    # Process received data here or store it for later use

def subscribe_topic(topic):
    client.subscribe(topic)
    print(f"Subscribed to topic '{topic}'")

def subscribe_function(topic):
    # Subscribe to the topic
    subscribe_topic(topic)
    # Start the MQTT client loop to receive messages
    connect_to_broker()
    # This loop will keep the client running to receive messages
    # You may want to handle this differently based on your application's requirements
    try:
        while True:
            pass  # This loop will continue indefinitely until interrupted
    except KeyboardInterrupt:
        disconnect_from_broker()



# Test publishing
#publish_to_mqtt_broker("Hello, MQTT!")

# Test subscribing
client.on_connect = on_connect
client.on_disconnect = on_disconnect
client.on_message = on_message

subscribe_function(topic_sub)
 """
import paho.mqtt.client as mqtt
from Config.config import *

# Global variables
broker_address = brocker_server 
broker_port = brocker_port
topic_pub = brocker_topic_pub
topic_sub= brocker_topic_sub
topic_open = brocker_topic_open

client = mqtt.Client()

def connect_to_broker():
    client.connect(broker_address, broker_port)
    client.loop_start()

def disconnect_from_broker():
    client.loop_stop()
    client.disconnect()



def publish_to_mqtt_broker_open(lpn: str):
    message = lpn
    
    client.connect(broker_address, broker_port)
    print(f"Connected to MQTT : {broker_address}")
    
    client.publish(topic_open, message)
    print(f"Published Topic : {topic_open}")
    print(f"Published message : {message}")

    client.disconnect()

    return {
        "mqtt_server": broker_address,
        "mqtt_topic_pub": topic_open
    }




# Test publishing
#publish_to_mqtt_broker("Hello, MQTT!")


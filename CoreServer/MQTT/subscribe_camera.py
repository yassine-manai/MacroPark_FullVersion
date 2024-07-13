import paho.mqtt.client as mqtt
from Config.config import *
from DB.check import *
from MQTT.publish import *
import datetime
import json

broker_address = brocker_server
broker_port = brocker_port
topic_pub = brocker_topic_pub
topic_sub = brocker_topic_sub

#Verif_Url = f"http://{APP_IP}:{Back_Port}{Verif_Url}"

#Log_Url = f"http://{APP_IP}:{Back_Port}{Log_Url}"

def on_message(client, userdata, message):
    payload = message.payload.decode()

    print("Received message:", payload)
    try:
        payload_json = json.loads(payload)
        check_and_publish(payload_json)
    except json.JSONDecodeError as e:
        print("Error decoding JSON:", e)


def check_and_publish(payload):

    result = get_user_info_lpn(payload["license"])
    # result = chek_lpn(Verif_Url, lpn=payload["license"],)
    print(result)

    if result:
        publish_to_mqtt_broker_open("open")

        current_time = datetime.datetime.now() + datetime.timedelta(hours=1)
        dateNow = current_time.strftime("%Y-%m-%d")
        timeNow = current_time.strftime("%H:%M:%S")

        event_data = {
            "id_user": result["user_id"],
            "user_name": result["user_name"],
            "user_email": result["user_email"],
            "MQTT Server": brocker_server,
            "MQTT Topic": brocker_topic_pub,
            "Methode": "Camera Action",
            "license": payload["license"],
            "minQuality": payload.get("minQuality", 0.5),
            "avgQuality": payload.get("avgQuality", "1"),
            "triggerId": payload.get("triggerId", 0),
            "deviceId": payload["Device_id"],
            "date": dateNow,
            "time": timeNow,
            "imageData": payload["image"]
        }

        create_event(event_data)
        #send_log(Log_Url, event_data)


def mqtt_subscriber_cam():
    client = mqtt.Client()

    client.on_message = on_message
    client.connect(brocker_server, broker_port)

    client.subscribe(topic_pub)

    print(topic_pub)
    client.loop_start()

def mainsubcam():

    mqtt_subscriber_cam()

    print("Subscribed to MQTT CAMERA topic and waiting for messages...")

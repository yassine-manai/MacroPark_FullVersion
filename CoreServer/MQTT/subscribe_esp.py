import paho.mqtt.client as mqtt
from Config.config import *
from DB.check import *
from MQTT.publish import *
import datetime
import json

broker_address = brocker_server
broker_port = brocker_port
topic_uid = brocker_topic_uid

#Verif_Url_Esp = f"http://{APP_IP}:{Back_Port}{Verif_Url_Esp}"

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

    user_id_prefix = int(str(payload["userID"])[:3])
    result = get_id_from_db(user_id_prefix)
    # result = chek_lpn(Verif_Url_Esp, lpn=payload["lpn"])
    print(f'result:{result}')

    if result:
        current_time = datetime.datetime.now() + datetime.timedelta(hours=1)
        dateNow = current_time.strftime("%Y-%m-%d")
        timeNow = current_time.strftime("%H:%M:%S")

        event_data = {
            "id_user": result["user_id"],
            "user_name": result["user_name"],
            "user_email": result["user_email"],
            "MQTT Server": brocker_server,
            "MQTT Topic": brocker_topic_pub,
            "Methode": "Phone Action",
            "license": "None",
            "minQuality": "0",
            "deviceId": payload["DeviceID"],
            "date": dateNow,
            "time": timeNow
        }

        print(event_data)

        create_event(event_data)
        #send_log(Log_Url, event_data)


def mqtt_subscriber_esp():
    client = mqtt.Client()

    client.on_message = on_message
    client.connect(brocker_server, broker_port)

    client.subscribe(topic_uid)

    # Start a loop to receive messages asynchronously
    client.loop_start()

def mainsubesp():
    mqtt_subscriber_esp()
    print("Subscribed to MQTT ESP topic and waiting for messages...")

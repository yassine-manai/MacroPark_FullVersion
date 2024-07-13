import os

def parse_config(file_path):
    config = {}
    with open(file_path, 'r') as file:
        for line in file:
            line = line.strip()
            if line and '=' in line:
                key, value = line.split('=', 1)
                config[key.strip()] = value.strip()
    return config

config = parse_config('Config/config.ini')

# Retrieving values as strings directly, without conversion
APP_IP = os.getenv("APP_IP") if os.getenv("APP_IP") else config.get('APP_IP')
APP_PORT = int(os.getenv("APP_PORT")) if os.getenv("APP_PORT") else int(config.get('APP_PORT'))

Verif_Url = os.getenv("VERIF_URL") if os.getenv("VERIF_URL") else config.get('VERIF_URL')
Log_Url = os.getenv("LOG_URL") if os.getenv("LOG_URL") else config.get('LOG_URL')
Verif_Url_Esp = os.getenv("VERIF_URL_ESP") if os.getenv("VERIF_URL_ESP") else config.get('VERIF_URL_ESP')

brocker_server = os.getenv("MQTT_SERVER") if os.getenv("MQTT_SERVER") else config.get('MQTT_SERVER')
brocker_port = int(os.getenv("MQTT_PORT")) if os.getenv("MQTT_PORT") else int(config.get('MQTT_PORT'))
brocker_topic_pub = os.getenv("MQTT_TOPIC_PUB") if os.getenv("MQTT_TOPIC_PUB") else config.get('MQTT_TOPIC_PUB')
brocker_topic_sub = os.getenv("MQTT_TOPIC_SUB") if os.getenv("MQTT_TOPIC_SUB") else config.get('MQTT_TOPIC_SUB')
brocker_topic_open = os.getenv("MQTT_TOPIC_OPEN") if os.getenv("MQTT_TOPIC_OPEN") else config.get('MQTT_TOPIC_OPEN')
brocker_topic_uid = os.getenv("MQTT_TOPIC_UID") if os.getenv("MQTT_TOPIC_UID") else config.get('MQTT_TOPIC_UID')

print("\n ")

print("-------------------------------- APP_IP:", APP_IP)
print("-------------------------------- APP_PORT:", APP_PORT)
print("-------------------------------- Verification LPN:", Verif_Url)
print("-------------------------------- Server MQTT : ", brocker_server)
print("-------------------------------- PORT MQTT: ", brocker_port)
print("-------------------------------- TOPIC MQTT PUBLISH : ", brocker_topic_pub)
print("-------------------------------- TOPIC MQTT SUBSCRIBE : ", brocker_topic_sub)

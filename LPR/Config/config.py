import configparser
import os

def add_default_section_header(file_path):
    with open(file_path, 'r') as file:
        content = file.read()
    
    if not content.startswith('['):
        with open(file_path, 'w') as file:
            file.write('[DEFAULT]\n' + content)

config_file_path = 'Config/config.ini'
add_default_section_header(config_file_path)

config = configparser.ConfigParser()
config.read(config_file_path)

APP_IP = os.getenv("APP_IP") if os.getenv("APP_IP") else config.get('DEFAULT', 'APP_IP')
APP_PORT = int(os.getenv("APP_PORT")) if os.getenv("APP_PORT") else config.getint('DEFAULT', 'APP_PORT')

Cam_username = os.getenv("Cam_username") if os.getenv("Cam_username") else config.get('DEFAULT', 'Cam_username')
Cam_password = os.getenv("Cam_password") if os.getenv("Cam_password") else config.get('DEFAULT', 'Cam_password')
Cam_id = os.getenv("Cam_id") if os.getenv("Cam_id") else config.get('DEFAULT', 'Cam_id')

brocker_server = os.getenv("MQTT_SERVER") if os.getenv("MQTT_SERVER") else config.get('DEFAULT', 'MQTT_SERVER')
brocker_port = int(os.getenv("MQTT_PORT")) if os.getenv("MQTT_PORT") else config.getint('DEFAULT', 'MQTT_PORT')
brocker_topic_pub = os.getenv("MQTT_TOPIC_PUB") if os.getenv("MQTT_TOPIC_PUB") else config.get('DEFAULT', 'MQTT_TOPIC_PUB')
# brocker_topic_sub = os.getenv("MQTT_TOPIC_SUB") if os.getenv("MQTT_TOPIC_SUB") else config.get('DEFAULT', 'MQTT_TOPIC_SUB')

print("\n ")

print("-------------------------------- APP_IP:", APP_IP)
print("-------------------------------- APP_PORT:", APP_PORT)

print("-------------------------------- Cam user:", Cam_username)
print("-------------------------------- Cam password:", Cam_password)

print("-------------------------------- Server MQTT : ", brocker_server)
print("-------------------------------- PORT MQTT: ", brocker_port)
print("-------------------------------- TOPIC MQTT PUBLISH : ", brocker_topic_pub)
# print("-------------------------------- TOPIC MQTT SUBSCRIBE : ", brocker_topic_sub)

print("\n ")

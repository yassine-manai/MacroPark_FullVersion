import uvicorn
from fastapi import FastAPI

from Config.config import *
from MQTT.subscribe_camera import mainsubcam
from MQTT.subscribe_esp import mainsubesp


# Initialize FastAPI app
app = FastAPI()
topic_pub = brocker_topic_pub



if __name__ == "__main__":

    mainsubcam()
    mainsubesp()

    uvicorn.run("main:app", host="0.0.0.0", port=APP_PORT)

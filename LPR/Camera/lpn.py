import base64
from fastapi import APIRouter, FastAPI, HTTPException, Request, Response
import httpx
from Config.publish_data import publish_to_mqtt_broker
from Models.Json import *
from Config.config import *

app = FastAPI()


PostOnCarHandled = APIRouter()
PostOnCarArrival = APIRouter()
PostOnCarDeparture = APIRouter()



# On Car Handled ------------------------------------------------------------- <-- POST-->
@PostOnCarHandled.post("/OnCarHandled")
async def OnCarHandled(request: OnCarHandledBase):
    try:
        print(" \n ")
        print("On Car Handled ------------------------------------------------------------- <-- POST-->")


        print(f"- - - - - - LPN = {request.license} - - - - - ")
        print(f"- - - - - - Min Quality = {request.minQuality} - - - - - ")
        print(f"- - - - - - Trigger ID = {request.triggerId} - - - - - ")
        print(f"- - - - - - Country = {request.country} - - - - - ")


        print(" \n ")

        print(request)

        print(" \n ")

        if request.minQuality < 0.5:
            endpoint_url = f"http://{APP_IP}:{APP_PORT}/WS/Trigger?triggerId={request.triggerId}"
            username = Cam_username
            password = Cam_password

            credentials = f"{username}:{password}"
            credentials = base64.b64encode(credentials.encode()).decode()
            headers = {
                "Authorization": f"Basic {credentials}",
                "Content-Type": "application/json"
           }

            async with httpx.AsyncClient() as client:
                response = await client.post(endpoint_url, headers=headers)

        if request.minQuality > 0.5:
            
            data_to_publish = {
                "license": request.license,
                "minQuality": request.minQuality,
                "avgQuality": request.avgQuality,
                "triggerId": request.triggerId,
                "Device_id": Cam_id,
                "image": request.imageData
            }
            
            publish_to_mqtt_broker(data_to_publish)

            return Response(content="data_published", status_code=200)


    except Exception as Ex:
        print(Ex)
        return HTTPException(status_code=404, detail="User not found")    



# On Car Departure ------------------------------------------------------------- <-- POST-->
""" @PostOnCarDeparture.post("/OnCarDeparture")
async def OnCarDeparture(request: OnCarHandledBase):
    try:
        print(" \n ")

        print("On Car Departure ------------------------------------------------------------- <-- POST-->")

        print(f"- - - - - - LPN = {request.license}")

        print(" \n ")

        if request.minQuality < 0.5:
            endpoint_url = f"http://{APP_IP}:{APP_PORT}/WS/Trigger?triggerId={request.triggerId}"
            username = Cam_username
            password = Cam_password

            credentials = f"{username}:{password}"
            credentials = base64.b64encode(credentials.encode()).decode()
            headers = {
                "Authorization": f"Basic {credentials}",
                "Content-Type": "application/json"
           }

            async with httpx.AsyncClient() as client:
                response = await client.post(endpoint_url, headers=headers)

        if request.minQuality > 0.5:
            
            data_to_publish = {
                "license": request.license,
                "minQuality": request.minQuality,
                "avgQuality": request.avgQuality,
                "triggerId": request.triggerId,
                "Device_id": Cam_id
            }
            
            publish_to_mqtt_broker(data_to_publish)

        return Response(content="OK", status_code=200)
    except Exception as Ex:
        print(Ex)
        return Response(content="Not Captured", status_code=404)
    
 """




# On Car Arrival ------------------------------------------------------------- <-- POST-->
@PostOnCarArrival.post("/OnCarArrival")
async def OnCarArrival(request: OnArrivalBase):
    try:
        print(" \n ")
        print("On Car Arrival ------------------------------------------------------------- <-- POST-->")

        print(f"- - - - - - LPN = {request.license} - - - - - ")
        print(f"- - - - - - Min Quality = {request.minQuality} - - - - - ")
        print(f"- - - - - - Trigger ID = {request.triggerId} - - - - - ")
        print(f"- - - - - - Country = {request.country} - - - - - ")
        print(" \n ")

        
        
        return Response(content=OnArrivalBase, status_code=200)
    except Exception as Ex:
        print(Ex)
        return Response(content="Not Captured", status_code=404)


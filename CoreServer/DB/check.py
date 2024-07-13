from fastapi import FastAPI, HTTPException, Response

from DB.ConnetionDB import *

app = FastAPI()

def setup_db_users():
    client, db, collection = connect_users()
    return client, db, collection

def setup_db_events():
    client, db, collection = connect_event()
    return client, db, collection



@app.post("/events")
def create_event(event_data: dict):
    client, db, collection = setup_db_events()
    result = collection.insert_one(event_data)
    if result.inserted_id:
        print("Event created successfully")
        return {"message": "Event inserted successfully"}
    else:
        raise HTTPException(status_code=500, detail="Failed to insert event")



@app.get("/lpn/{lpn}")
def get_user_info_lpn(lpn: str):
    _, _, collection = setup_db_users()
    user_data = collection.find_one(
        {
            "$or": [
                {"lpn1": lpn},
                {"lpn2": lpn},
                {"lpn3": lpn},
                {"lpn4": lpn}
            ]
        }
    )
    if user_data:
        user_id = user_data.get("_id")
        user_name = user_data.get("name")
        user_email = user_data.get("email")

        response_content = {"user_email": user_email, "user_id": user_id, "user_name": user_name}
        print(response_content)

        return response_content
    


@app.get("/iduser/{id}")
def get_id(id: int):

    print(id)
    _, _, collection = setup_db_users()    

    user = collection.find_one({"_id": int(id)})
        

    if user:
        user_id = user.get("_id")
        user_name = user.get("name")
        user_email = user.get("email")

        response_content = {"user_email": user_email, "user_id": user_id, "user_name": user_name}

        return response_content




def get_id_from_db(id):
    _, _, collection = setup_db_users()    
    user = collection.find_one({"_id": int(id)})

    if user:
        user_id = user.get("_id")
        user_name = user.get("name")
        user_email = user.get("email")


        response_content = {"user_email": user_email, "user_id": user_id, "user_name": user_name}


        return response_content
    
    return False


def check_lpn(url, lpn):
    try:
        response = requests.get(url, params={"lpn": lpn})
        if response.status_code == 200:
            print(response.content)
            return response.json()
        elif response.status_code in {400, 401, 402, 404, 500}:
            return {}
        else:
            return f"Unexpected status code: {response.status_code}"
    except requests.RequestException as e:
        return f"Error: {e}"



def send_log(url, data):
    try:
        response = requests.post(url, json=data)
        print(response)
        if response.status_code == 200:
            return response  
        elif response.status_code == 404:
            return {}
        else:
            return f"Unexpected status code: {response.status_code}"
    except requests.RequestException as e:
        return f"Error: {e}"



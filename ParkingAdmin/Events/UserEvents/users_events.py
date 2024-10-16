from bson import ObjectId
from fastapi import APIRouter, FastAPI, HTTPException
from Database.DB.Connection import connect_events


app = FastAPI()

# Database connection
async def setup_db():
    client, db, collection = await connect_events()
    return client, db, collection


# Define routers - APIs()
UserLogsList = APIRouter()
UserByDate = APIRouter()
UserByOid = APIRouter()
UserByid = APIRouter()

# Get all Users Logs - API()
@UserLogsList.get('/alluserevents', tags=["Events"])
async def get_all_userEvents():
    _, _, collection = await setup_db()
    
    users = await collection.find().to_list(length=None)
    
    formatted_users = []
    reversed_users = list(reversed(users))
    for user in reversed_users:  
        user['_id'] = str(user['_id'])  
        formatted_users.append(user)
    
    return {"users": formatted_users}



@UserByDate.get('/usersLogs/{date}', tags=["Events"])
async def find_users_by_date(date: str):
    _, _, collection = await setup_db()
    
    cursor = collection.find({'date': date})
    users = await cursor.to_list(length=None)
    
    if users:
        reversed_users = list(reversed(users))
        for user in reversed_users:
            user['_id'] = str(user['_id'])
        return {"users": reversed_users}
    else:
        raise HTTPException(status_code=404, detail='Logs not found')


@UserByOid.get('/usersoid/{id}', tags=["Events"])
async def find_users_Log_by_id(id: str):
    _, _, collection = await setup_db()
    
    try:
        object_id = ObjectId(id)
    except Exception as e:
        raise HTTPException(status_code=400, detail='Invalid ObjectId format')
    
    user = await collection.find_one({'_id': object_id}, {'imageData': 1})
    
    if user:
        user['_id'] = str(user['_id'])
        return {"id": user['_id'], "imageData": user.get('imageData')}
    else:
        raise HTTPException(status_code=404, detail='Log not found')


@UserByid.get('/userappid/{id}', tags=["Events"])
async def find_users_by_app_id(id: int):
    _, _, collection = await setup_db()
    
    fields = {
        'id_user': 1,
        'user_name': 1,
        'Methode': 1,
        'license': 1,
        'deviceId': 1,
        'minQuality': 1,
        'date': 1,
        'time': 1,
        'imageData': 1
    }
    
    cursor = collection.find({'id_user': id}, fields)
    users = await cursor.to_list(length=None)
    
    if users:
        reversed_users = list(reversed(users))
        for user in reversed_users:
            user['_id'] = str(user['_id'])
        return {"users": reversed_users}
    else:
        raise HTTPException(status_code=404, detail='Logs not found')
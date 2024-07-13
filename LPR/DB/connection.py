from pymongo import MongoClient


client = MongoClient("mongodb://localhost:27017/")
db = client.Parking

async def connect_users():
    collection = db.Users
    return client, db, collection


async def connect_event():
    collection = db.Events
    return client, db, collection
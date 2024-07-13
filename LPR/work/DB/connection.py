from pymongo import MongoClient


client = MongoClient("mongodb+srv://sbm2024:sbm2024_projet@cluster0.pud7wkc.mongodb.net/")
db = client.Parking

async def connect_users():
    collection = db.Users
    return client, db, collection


async def connect_event():
    collection = db.Events
    return client, db, collection
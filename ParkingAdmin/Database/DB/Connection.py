from motor.motor_asyncio import AsyncIOMotorClient


client = AsyncIOMotorClient("mongodb://192.168.25.59:27017")
db = client.Parking

async def connect_users():
    collection = db.Users
    return client, db, collection

async def connect_guests():
    collection = db.Guests
    return client, db, collection


async def connect_events():
    collection = db.UsersLogs
    return client, db, collection


async def connect_config():
    collection = db.Config
    return client, db, collection


async def connect_Lpns():
    collection = db.Lpns
    return client, db, collection
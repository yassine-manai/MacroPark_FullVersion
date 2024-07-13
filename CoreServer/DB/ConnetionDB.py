import requests
from pymongo import MongoClient

def check_lpn(url, lpn):
    try:
        response = requests.get(url, params={"lpn": lpn})
        if response.status_code == 200:
            return response
        elif response.status_code == 404:
            return {}
        else:
            return f"Unexpected status code: {response.status_code}"
    except requests.RequestException as e:
        return f"Error: {e}"




client = MongoClient("mongodb://192.168.25.59:27017")
db = client.Parking

def connect_users():
    collection = db.Users
    return client, db, collection


def connect_event():
    collection = db.UsersLogs
    return client, db, collection
import uvicorn
from fastapi import FastAPI

from Camera.lpn import PostOnCarHandled
from Config.config import APP_PORT



app = FastAPI()


# LPN CAMERA Endpoints ----------------------------------------------------------- <-- Begin -->

#app.include_router(PostOnCarArrival)
app.include_router(PostOnCarHandled)
#app.include_router(PostOnCarDeparture)



# Define the path to save the log file
if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=APP_PORT, reload=True)

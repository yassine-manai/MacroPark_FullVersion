import binascii
from pydantic import BaseModel, EmailStr
from fastapi import HTTPException
from Config.log_config import logger
import socket

# User Event Camera Class
class UserEvent(BaseModel):
    id: str
    user_name: str
    user_email: str
    MQTT_Server: str
    MQTT_Topic: str
    license: str
    minQuality: float
    avgQuality: float
    triggerId: int
    country: str
    date: str
    time: str

# Barrier Class
class BarrierItem(BaseModel):
    name:str
    id: int
    barrierType:str
    ip: str
    port: int = 52719

class EmailRequest(BaseModel):
    to: str
    subject: str
    body: str

class SMSRequest(BaseModel):
    phone_number: str
    message: str

class ChangePasswordRequest(BaseModel):
    email: str
    password: str

class BarrierCmd(BaseModel):
    op_cmd: str = "55 03 01 01 00 B8 B4"
    cl_cmd: str = "55 03 01 02 00 ED E7"
    lk_cmd: str = "55 03 01 01 01 A8 95"
    uk_cmd: str = "55 03 01 01 02 98 F6"
    st_cmd: str = "55 02 02 02 65 FE"


class ModifiedBarrierItem(BaseModel):
    name:str
    id: int
    type:str
    ip: str
    port: int


# User Class
class userItem(BaseModel):
    id: int
    name: str
    phoneNumber: str
    email: str
    password: str
    lpn1: str
    lpn2: str
    lpn3: str
    lpn4: str

class UpdateUserData(BaseModel):
    name: str
    email: str
    phoneNumber: str
    password: str
    lpn1: str
    lpn2: str

    class Config:
        schema_extra = {
            "example": {
                "name": "Name",
                "email": "mail@example.com",
                "phoneNumber": "1234567890",
                "password": "password",
                "lpn1":" ", 
                "lpn2": " "
            }
        }

class Updateweb(BaseModel):
    name: str
    email: str
    phoneNumber: str
    lpn1: str
    lpn2: str
    lpn3: str
    lpn4: str

    class Config:
        schema_extra = {
            "example": {
                "name": "Yassine",
                "phoneNumber": "93014027",
                "email": "yas",
                "lpn1": "1624 TU 199",
                "lpn2": "1623 TU 199",
                "lpn3": "1621 TU 199",
                "lpn4": "1620 TU 199"
            }
        }


class guestItem(BaseModel):
    id: int
    name: str
    phoneNumber: str
    email: str
    password: str
    lpn1: str
    lpn2: str
    lpn3: str
    lpn4: str


# Action to barrier 

def send_action(ip_address, port, hex_code, action):
    try:
        # Create a TCP socket
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            try:
                # Attempt to connect to the IP address and port
                s.connect((ip_address, port))
            except ConnectionRefusedError as conn_refused_error:
                # Handle connection refused error
                error_msg = f"Connection refused to {ip_address}:{port}: {str(conn_refused_error)}"
                logger.error(error_msg)
                raise HTTPException(status_code=500, detail={"errordata": 500, "message": error_msg})
            except Exception as conn_error:
                # Handle other connection errors
                error_msg = "errordata:501"
                logger.error(error_msg)
                raise HTTPException(status_code=500, detail={"errordata": 500, "message": "error establish connection with the barrier"})
                
            # Convert hex code to bytes
            hex_bytes = bytes.fromhex(hex_code)
            
            # Send the hex code
            s.sendall(hex_bytes)
            
            # Log action
            logger.info(f"Action '{hex_code}' sent to {ip_address}:{port}")
        
        # Return success message
        return {"message": f"Barrier {action} with {ip_address}:{port} using {hex_code}"}
    
    except Exception as e:
        # Log error and raise HTTPException
        logger.error(f"Error sending Action '{hex_code}' to {ip_address}:{port}: {str(e)}")
        raise HTTPException(status_code=500, detail={"errordata": 500, "message": "error sending action to the barrier"})
    

async def send_action_with_timeout(ip_address, port, hex_code, action, timeout):
    try:
        # Create a TCP socket
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.settimeout(timeout)  # Set a timeout for socket operations

            try:
                # Attempt to connect to the IP address and port
                s.connect((ip_address, port))
            except ConnectionRefusedError as conn_refused_error:
                # Handle connection refused error
                error_msg = f"Connection refused to {ip_address}:{port}: {str(conn_refused_error)}"
                logger.error(error_msg)
                raise HTTPException(status_code=500, detail={"errordata": 500, "message": error_msg})
            except Exception as conn_error:
                # Handle other connection errors
                error_msg = f"Error establishing connection to {ip_address}:{port}: {str(conn_error)}"
                logger.error(error_msg)
                raise HTTPException(status_code=500, detail={"errordata": 500, "message": error_msg})
                
            # Convert hex code to bytes
            hex_bytes = bytes.fromhex(hex_code)
            
            # Send the hex code
            s.sendall(hex_bytes)
            
            # Log action
            logger.info(f"Action '{hex_code}' sent to {ip_address}:{port}")
        
        # Return success message
        return {"message": f"Barrier {action} with {ip_address}:{port} using {hex_code}"}
    
    except Exception as e:
        # Log error and raise HTTPException
        logger.error(f"Error sending Action '{hex_code}' to {ip_address}:{port}: {str(e)}")
        raise HTTPException(status_code=500, detail={"errordata": 500, "message": "error sending action to the barrier"})
    



def response(ip_address, port, hex_code, action):
    BUFFER_SIZE = 1024
    
    try:
        # Create a TCP socket
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            try:
                # Attempt to connect to the IP address and port
                s.connect((ip_address, port))
            except ConnectionRefusedError as conn_refused_error:
                # Handle connection refused error
                error_msg = f"Connection refused to {ip_address}:{port}: {str(conn_refused_error)}"
                raise HTTPException(status_code=500, detail={"errordata": 500, "message": error_msg})
            
            except Exception as conn_error:
                # Handle other connection errors
                error_msg = f"Error establishing connection to {ip_address}:{port}: {str(conn_error)}"
                raise HTTPException(status_code=500, detail={"errordata": 500, "message": error_msg})
                
            # Convert hex code to bytes
            hex_bytes = bytes.fromhex(hex_code)
            
            # Send the hex code
            s.sendall(hex_bytes)

            # Set timeout for receiving data
            s.settimeout(5)  # 5 seconds timeout
            
            try:
                # Receive data
                data = s.recv(BUFFER_SIZE)
                rec_data = binascii.hexlify(data).decode('utf-8')
                
                # Log received data
                print(f"data received is {rec_data}")

                # Log action
                print(f"Action '{hex_code}' sent to {ip_address}:{port}")

                # Return success message and response separately
                return {"message": f"Barrier {action} with {ip_address}:{port} using {hex_code}", "response": rec_data}
            except socket.timeout:
                # Handle timeout error
                error_msg = f"Timeout occurred while waiting for response from {ip_address}:{port}"
                raise HTTPException(status_code=500, detail={"errordata": 500, "message": error_msg})
            except Exception as recv_error:
                # Handle other receive errors
                error_msg = f"Error receiving response from {ip_address}:{port}: {str(recv_error)}"
                raise HTTPException(status_code=500, detail={"errordata": 500, "message": error_msg})
    
    except Exception as e:
        # Log error and raise HTTPException
        error_msg = f"Error sending Action '{hex_code}' to {ip_address}:{port}: {str(e)}"
        raise HTTPException(status_code=500, detail={"errordata": 500, "message": error_msg})

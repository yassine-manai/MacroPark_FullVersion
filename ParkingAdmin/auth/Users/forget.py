from fastapi import APIRouter, FastAPI, HTTPException
from pydantic import BaseModel
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

from Models.items import EmailRequest

app = FastAPI()

Send_Email = APIRouter()

SMTP_SERVER = '' 
SMTP_PORT = 465 
SMTP_USERNAME = 'n'  
SMTP_PASSWORD = 'Tester142536'


def send_email(to_address, subject, body):
    msg = MIMEMultipart()
    msg['From'] = SMTP_USERNAME
    msg['To'] = to_address
    msg['Subject'] = subject

    msg.attach(MIMEText(body, 'plain'))

    try:
        server = smtplib.SMTP_SSL(SMTP_SERVER, SMTP_PORT)  
        server.ehlo()
        server.login(SMTP_USERNAME, SMTP_PASSWORD)
        text = msg.as_string()
        server.sendmail(SMTP_USERNAME, to_address, text)
        server.quit()
        return True
    except Exception as e:
        print(f"Failed to send email: {e}")
        return False

@Send_Email.post("/send_email", tags=["Reset"])
async def send_email_endpoint(email_request: EmailRequest):
    if send_email(email_request.to, email_request.subject, email_request.body):
        print(EmailRequest)
        return {"message": "Email sent successfully"}
    else:
        raise HTTPException(status_code=500, detail="Failed to send email")

app.include_router(Send_Email)

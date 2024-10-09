#FROM python:3.12-slim
#WORKDIR /app
#COPY . /app
#COPY ./requirements.txt /app/requirements.txt
#RUN pip install --no-cache-dir -r /app/requirements.txt
#CMD ["python3", "/app/main.py"]


FROM python:3.12-slim

WORKDIR /app
COPY . /app

COPY ./requirements.txt /app/requirements.txt

RUN pip install --no-cache-dir -r /app/requirements.txt

ENTRYPOINT ["python3", "/app/main.py"]

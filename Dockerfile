# Use an official Python runtime as a base image
FROM python:3.9-alpine

# Install requirements.txt
RUN pip install -U paramiko

RUN env

COPY entrypoint.py /app/entrypoint.py
RUN chmod a+x /app/entrypoint.py
ENTRYPOINT ["python3", "/app/entrypoint.py"]

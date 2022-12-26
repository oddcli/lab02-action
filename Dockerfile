# Use an official Python runtime as a base image
FROM python:3.9
# Set the working directory
WORKDIR /app
# Install requirements.txt
RUN pip install -U paramiko
# Copy the entrypoint script and make it executable
RUN pwd && ls -ls ./

COPY entrypoint.py .
RUN chmod +x entrypoint.py

RUN pwd && ls -ls ./
# Set the entrypoint script as the default command
ENTRYPOINT ["./entrypoint.py"]

# Use an official Python runtime as a base image
FROM python:3.9
# Set the working directory
WORKDIR /
# Install requirements.txt
RUN pip install -U paramiko
COPY entrypoint.py /entrypoint.py
RUN chmod a+x /entrypoint.py
RUN env
ENTRYPOINT ["python3", "/entrypoint.py"]

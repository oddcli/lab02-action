# Use an official Python runtime as a base image
FROM python:3.9

# Install requirements.txt
RUN pip install -U paramiko

ENV VPS_LIST_FILE="$VPS_LIST_FILE"
ENV DEPLOY_COMMAND="$DEPLOY_COMMAND"
ENV USERNAME="$USERNAME"
ENV SSH_KEY="$SSH_KEY"

RUN env && echo "$VPS_LIST_FILE $DEPLOY_COMMAND"

COPY entrypoint.py /app/entrypoint.py
RUN chmod a+x /app/entrypoint.py
ENTRYPOINT ["python3", "/app/entrypoint.py"]

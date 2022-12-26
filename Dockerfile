# Use an official Python runtime as a base image
FROM python:3.9

# Install requirements.txt
RUN pip install -U paramiko

ENV VPS_LIST_FILE=${{ inputs.vps_list_file }}
ENV DEPLOY_COMMAND=${{ inputs.deploy_command }}
ENV SSH_KEY=${{ inputs.ssh_key }}
ENV USERNAME=${{ inputs.username }}

RUN env && echo "$VPS_LIST_FILE $DEPLOY_COMMAND"

COPY entrypoint.py /app/entrypoint.py
RUN chmod a+x /app/entrypoint.py
ENTRYPOINT ["python3", "/app/entrypoint.py"]

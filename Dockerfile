    # Use an official Python runtime as a base image
    FROM python:3.9
    # Set the working directory
    WORKDIR /app
    # Install requirements.txt
    RUN pip install -U -r requirements.txt
    # Copy the entrypoint script and make it executable
    COPY entrypoint.py .
    RUN chmod +x entrypoint.py
    # Set the entrypoint script as the default command
    ENTRYPOINT ["./entrypoint.py"]

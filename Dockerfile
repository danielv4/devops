FROM ubuntu:18.04

EXPOSE 5000

RUN apt-get update -y
RUN apt-get install -y python
RUN apt-get install -y python-pip


WORKDIR /opt/webapp
COPY webapp ./
RUN pip install -r requirements.txt


ENTRYPOINT ["python", "/opt/webapp/app.py"]
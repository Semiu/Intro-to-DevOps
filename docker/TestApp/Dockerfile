FROM python:alpine3.21
COPY . /app
WORKDIR /app
RUN apk add --no-cache python3 py3-pip
RUN pip install -r requirements.txt
EXPOSE 5000
CMD python ./index.py
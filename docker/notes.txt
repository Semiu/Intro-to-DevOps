# Commands
docker build -t <IMAGE_NAME> .
docker run --name <CONTAINER_NAME> -p <PORT>:<PORT> <IMAGE_NAME>
docker ps # describing running containers
docker exec --help
docker rm 
docker rmi # to remove an image
docker login # to login into docker hub
docker tag SOURCE_IMAGE[:TAG] TARGET_IMAGE[:TAG]
docker push TARGET_IMAGE[:TAG] # pull
docker volume create <VOLUME_NAME>
docker volume list

# Notes
Images are composed of series of read-only layers built based on the instruction in the Dockerfile.
A container is a running instance of an image. Once an image is built, it's immutable. Only a new image would be build

You can extend an existing image 
In the docker file, you can do something like 
FROM semitoje/testimagerepo:v0
RUN pip3 install NLTK

-- like using your existing image as a base image for another image to be built.
Volume in docker is a storage file
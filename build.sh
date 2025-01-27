docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker rmi -f $(docker images -aq)
# rails generate dockerfile --force
docker build --no-cache --progress=plain .

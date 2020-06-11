# IdeaSpaceVR-Docker
IdeaSpaceVR Docker Container based on the php7.x docker image. Required extensions are being installed and apache configured.

This image does not include a mysql database. You need to have a mysql datbase already running with user and database prepared for this installation.

## Build and Run

Modify `docker-compose.yml` to fit your setup. 
```
docker-compose build && docker-compose up 
```

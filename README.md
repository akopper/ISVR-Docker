# IdeaSpaceVR-Docker
IdeaSpaceVR Docker Container based on the php7.x docker image. Required extensions are being installed and apache configured.

This image does not include a mysql database. You need to have a mysql database already running with user and database prepared for this installation.

## Build and Run

Modify `docker-compose.yml` to fit your setup. 
```
docker-compose build && docker-compose up 
```
Complete the setup.
Then copy the database.php file onto your host.
```
docker cp ideaspacevr:/var/www/html/config/database.php ./
```
Restart the container with the mounted `database.php`.

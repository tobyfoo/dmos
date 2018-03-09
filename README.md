# dmos

Dockerized Mongoose-OS tools.

This project is about installing and running the [Mongoose-OS](https://mongoose-os.com/) tools from a docker image.

You do not have to pollute your original operating system, with installing the several libs and the app itself.
Instead you only need docker to be installed.

At the same time you can keep your projects on your disk, that the docker container will reach through volumes.


## Use the container

First you need to build the image yourself because I'm not pushing it to Docker Hub.
```bash
  git clone https://github.com/tobyfoo/dmos
  cd dmos
  docker build -t tobyfoo/dmos .
```  

Here is a useful script to start a container with sensible options. The container's .mos directory is mounted to the 
current directory's mos-workspace directory.

```bash
  #!/bin/bash
  # Starts the Mongoose-OS utils using the docker image.
  
  SERIAL_PORT=/dev/ttyUSB0    # Define the serial port you are willing to use
  
  MOS_HOME=$PWD/dmos-workspace
  if [ ! -d "$MOS_HOME" ]; then
  echo "Workspace directory MOS_HOME does not exist!"
  exit 1
  fi
    
  docker run \
    -it \
    --rm \
    --privileged \
    -p 9992:9992 \
    -v $SERIAL_PORT:$SERIAL_PORT \
    -v $MOS_HOME:/home/developer/dmos-workspace \
    --name dmos \
    tobyfoo/dmos:latest \
    /bin/bash
```

Set the serial port you are using when communicate via the USB cable. Ensure the serial device (e.g. /dev/ttypUSB0) has 
permissions for either your user or (better) the dialout group.

The container will be removed after the session.
In case you want to persist changes, start the container without the `--rm` switch.

If you want to use the tool in several, parallel console sessions, 
then start the container and use the `docker exec` command for additional terminals:

```bash
    docker exec -it dmos bash
```

If you want to use the mos web UI on your host system you need to use the proxy provided, 
```bash
    go run proxy.go &
```
and then start 
```bash
    mos ui
```
Now you can access http://localhost:9992 on your browser. (The reason for using the proxy is that the mos tool binds to 
127.0.0.1 and there currently is no way to change this. Perhaps this can be configured in mos one day, then we no longer
 need the proxy.)



Read about [how to do the first steps with dmos](mos.md),
and learn more about the usage of the `mos` tool on the [Mongoose-OS](https://mongoose-os.com/) website.

## TODO

- TODO: mount .mos as a volume instead of /home/developer/projects and .../sandbox. Add this to Dockerfile too.
- TODO: remode dmos.sh and rather document docker commandlined for creating and starting container.
- TODO: check if /dev/ttyUSB0 allowed to be accessed by user (on my host system, ttyUSB0 was root:root so had to change to root:dialout there)
- TODO: allow container to run in detatched mode instead of bash only, i.e. start proxy and mos
- TODO: go build proxy then no need for golang-go and all of these packages...
- TODO: check if --privileged is really needed
- finish documentation

## References

- [Mongoose-OS](https://mongoose-os.com/)
- [Mongoose-OS - Installation on Linux or MacOS](https://mongoose-os.com/software.html)

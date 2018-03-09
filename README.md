# dmos

Dockerized Mongoose-OS tools.

This project is about installing and running the [Mongoose-OS](https://mongoose-os.com/) tools from a docker image.

You do not have to pollute your original operating system, with installing the several libs and the app itself.
Instead you only need docker to be installed.

At the same time you can keep your projects on your disk, that the docker container will reach through volumes.


## Use the container

This repository contains the [`dmos.sh`](dmos.sh) bash script, that you can use to start the `mos` tool.

```bash
    #!/bin/bash
    # Starts the Mongoose-OS utils using the docker image.

    PROJECTS=$HOME/topics       # Set the base path to your topics/projects directory
    SANDBOX=$HOME/sandbox/mos   # Set the base path to your sandbox directory
    SERIAL_PORT=/dev/ttyUSB0    # Define the serial port you are willing to use

    docker run \
        -it \
        --rm \
        --privileged \
        -e DISPLAY=$DISPLAY \
        -p 9992:9992 \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v $SERIAL_PORT:$SERIAL_PORT \
        -v $PROJECTS:/home/developer/projects \
        -v $SANDBOX:/home/developer/sandbox \
        tombenke/dmos:latest \
        /bin/bash
```

First time you should execute the following steps:

1. Copy the `dmos.sh` script somewhere in your `$PATH` (`$HOME/bin/` for example).
2. Set the volume references to your project and sandbox folders, as you can see in the code example above.
3. Also set the serial port you are using when communicate via the USB cable. Ensure the serial device (e.g. /dev/ttypUSB0) has permissions to access by either your user or (better) the dialout group.

In order to start the container, execute the `dmos.sh` script.
It starts a container named `dmos`. You can exit from the session simply by pressing Ctrl-D.

The container will be removed after the session.
In case you want to make changes, start the container without the `--rm` switch, 
and execute the `commit` and `push` docker commands.

If you want to use the tool in several, parallel console sessions, 
then start the container with the `dmos.sh` script and use the `docker exec` command:

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

- TODO: check if /dev/ttyUSB0 allowed to be accessed by user (on my host system, ttyUSB0 was root:root so had to change to root:dialout there)
- TODO: allow container to run in detatched mode instead of bash only, i.e. start proxy and mos
- TODO: go build proxy then no need for golang-go and all of these packages...
- TODO: check if --privileged is really needed
- finish documentation

## References

- [Mongoose-OS](https://mongoose-os.com/)
- [Mongoose-OS - Installation on Linux or MacOS](https://mongoose-os.com/software.html)

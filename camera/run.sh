#!/bin/sh

# Lots of help from http://wiki.ros.org/docker/Tutorials/GUI
#
XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
touch $XAUTH

xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

exec docker run -it --rm --privileged \
                --volume=$XSOCK:$XSOCK:rw \
                --volume=$XAUTH:$XAUTH:rw \
                --env="XAUTHORITY=${XAUTH}" \
                --env="DISPLAY" \
            chdkptp \
            $@

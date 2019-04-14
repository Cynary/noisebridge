#!/bin/sh

SCRIPT=$(readlink -f $0)
SCRIPT_PATH=$(dirname "$SCRIPT")
cd $SCRIPT_PATH

EXTENSION=""
if [ -f ./Dockerfile.$1 ]
then
    EXTENSION=".$1"

    echo "Running image tagged chdkptp$EXTENSION"
    echo "If you wished to run the $1 command in chdkptp, then run $0 -- $@ instead."

    shift
fi

if [ "$1" = "--" ]
then
    shift
fi

if ! [ -z "$DISPLAY" ]
then
    # Lots of help from http://wiki.ros.org/docker/Tutorials/GUI
    #
    XSOCK=/tmp/.X11-unix
    XAUTH=/tmp/.docker.xauth
    touch $XAUTH

    xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -
fi

exec docker run -it --rm --privileged \
                --volume=$XSOCK:$XSOCK:rw \
                --volume=$XAUTH:$XAUTH:rw \
                --env="XAUTHORITY=${XAUTH}" \
                --env="DISPLAY" \
            chdkptp"$EXTENSION" \
            $@

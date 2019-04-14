#!/bin/sh

set -e

# Ensure user exists.
#
if [ "$(id -u)" != "0" ]
then
    NEW_USER=chdkuser
    /scratch-chdkptp/create_user $(id -u) $NEW_USER
    sudo chown -R $NEW_USER:$NEW_USER $PWD
fi

exec $@

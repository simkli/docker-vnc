#!/bin/sh

# cleanup old X locks
rm -r /tmp/.X*-lock
rm -r /tmp/.X11-unix

# set user and group id
usermod -u $USER_ID -g $GROUP_ID user


# start supervisord
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf

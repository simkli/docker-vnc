FROM debian:bullseye-slim

# install supervisord
RUN apt-get update && apt-get install -y \
	supervisor

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf


# desktop environment
ENV DEBIAN_FRONTEND=noninteractive
#RUN apt-get install -y lxde-core
#RUN apt-get install -y icewm
RUN apt-get install -y openbox


# VNC Server
RUN apt-get install -y tightvncserver

# VNC clienti and websockify proxy
RUN apt-get install -y novnc websockify

# Install webserver caddy
RUN apt-get install -y debian-keyring debian-archive-keyring apt-transport-https curl \
	&& curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | apt-key add - \
	&& curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list \
	&& apt-get update \
	&& apt-get -y install caddy

# setup a user
RUN useradd -u 1000 -ms /bin/bash user

# Setup programs
RUN apt-get install -y firefox-esr xterm

WORKDIR /home/user

# Environment defaults
ENV USER_ID=1000 \
    GROUP_ID=1000 \    	
    DISPLAY_RESOLUTION=1260x800 \
    VNC_SERVER_PORT=5901 \
    VNC_START_CMD=openbox \
    VNC_PASSWORD=123456 \
    WEBSOCKIFY_PORT=5900 

# Setup Entrypoint
COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
#CMD /usr/bin/entrypoint.sh
#CMD cat

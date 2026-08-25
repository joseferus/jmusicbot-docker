FROM trfore/docker-debian11-systemd

ENV RUNLEVEL=1

RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d
RUN chmod +x /usr/sbin/policy-rc.d

RUN apt-get update
RUN apt-get --assume-yes install openjdk-11-jre-headless wget curl grep
RUN mkdir /app
RUN mkdir -p /config/Playlists
RUN ln -s /config/Playlists /app/Playlists
RUN ln -s /config/serversettings.json /app/serversettings.json

STOPSIGNAL SIGTERM

# ENV BOT_VERSION="latest"
# ENV BOT_GITHUB="jellyo-o/JellyoMusicBot"

COPY run_bot.sh /app/run_bot.sh
COPY install_docker.sh /app/install_docker.sh
COPY jmusicbot.service /etc/systemd/system/jmusicbot.service

RUN systemctl daemon-reload && systemctl enable jmusicbot.service
RUN chmod +x /app/run_bot.sh
RUN chmod +x /app/install_docker.sh

WORKDIR /app
VOLUME /config

CMD ["/lib/systemd/systemd"]

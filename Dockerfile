FROM bitnami/minideb:bullseye

RUN install_packages openjdk-11-jre-headless wget curl grep \
  && mkdir /app \
  && mkdir -p /config/Playlists \
  && ln -s /config/Playlists /app/Playlists \
  && ln -s /config/serversettings.json /app/serversettings.json

STOPSIGNAL SIGTERM

ENV BOT_VERSION="latest"
ENV BOT_GITHUB="jellyo-o/JellyoMusicBot"

COPY run_bot.sh /app/run_bot.sh
COPY install_docker.sh /app/install_docker.sh
RUN chmod +x /app/run_bot.sh
RUN chmod +x /app/install_docker.sh

WORKDIR /app
VOLUME /config

RUN ["./install_docker"]
CMD ["./run_bot.sh"]

# JMusicBot Docker

A simple Docker container for [JMusicBot](https://github.com/SeVile/MusicBot). The container will start up, then download JMusicBot from the projects repository and run it.  
The current YouTube source requires docker to be installed _inside_ the container itself, this fork adds a step to do this since it would need to be done manually (which can be a hassle) and redone if the container is ever removed.

## Usage
- Place your **config.txt**, **Playlists** folder, and **serversettings.json** file (if you have one) in `/your/path/to/config`. This directory will be shared with the container.
  > Refer to the documentaion on how to [configure the bot](https://jmusicbot.com/setup/#3-configure-the-bot)
- You can specify a JMusicBot version using the environment variable `BOT_VERSION`. By default the latest version will be downloaded so you don't have to include the variable if you want to use latest.
  > The version numbers you can use correspond to the [releases](https://github.com/SeVile/MusicBot/releases) tag, not the release name.
- Optionally, specify a JMusicBot repository to use by the environment variable `BOT_GITHUB`. This is ideal for using forks of the main repo when something breaks, and no fixes are yet available. It is recommended to set `updatealerts=false` in the bot config when using this option. By default this will be the SeVile's fork of the original repository, `SeVile/MusicBot`.
  > - [SeVile/MusicBot](https://github.com/SeVile/MusicBot/)
  > - [jagrosh/MusicBot](https://github.com/jagrosh/MusicBot)


### Docker examples
- Using docker cli
```bash
docker run -dit \  
  --name=jmusicbot \
  -v /your/path/to/config:/config \
  --restart=unless-stopped \
  ghcr.io/yojoshb/jmusicbot-docker
```

- Using docker compose
```yaml
---
services:
  jmusicbot:
    image: ghcr.io/yojoshb/jmusicbot-docker
    container_name: jmusicbot
    environment:
      - BOT_VERSION=0.3.9 # Optional. Will default to the 'latest' release
      - BOT_GITHUB=jagrosh/MusicBot # Optional. In the format {Owner}/{Repository}
    volumes:
      - /your/path/to/config:/config
    restart: unless-stopped
```

---

#### Debugging
- If you need to access the container you can hop into it and get a shell using:
```bash
docker exec -it jmusicbot /bin/bash
```

- Or read the logs:
```bash
docker logs jmusicbot
```

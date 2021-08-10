@echo off

set volume=%localappdata%\gitlab

docker run -d^
    --hostname localhost^
    --publish 443:443 --publish 80:80 --publish 22:22^
    --name gitlab^
    --restart always^
    --volume %volume%\config:/etc/gitlab^
    --volume %volume%\logs:/var/log/gitlab^
    --volume %volume%\data:/var/opt/gitlab^
    gitlab/gitlab-ce:13.12.10-ce.0

docker start gitlab

docker exec -ti gitlab /bin/bash

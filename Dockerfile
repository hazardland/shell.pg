FROM postgres:12.3

ENV POSTGRES_PASSWORD=1234

WORKDIR /usr/src/project

RUN apt update && apt install -y mc git python3 python3-pip cmake postgresql-server-dev-12 && pip3 install powerline-status powerline-gitstatus
RUN pip3 install psycopg2-binary

RUN cd /usr/src/ && git clone https://github.com/hazardland/pgquarrel.git ./pgquarrel && cd ./pgquarrel && cmake . && make && make install

RUN mkdir -p ~/.config/powerline

RUN echo "\n\
powerline-daemon -q \n\
POWERLINE_BASH_CONTINUATION=1 \n\
POWERLINE_BASH_SELECT=1 \n\
\n\
. /usr/local/lib/python3.7/dist-packages/powerline/bindings/bash/powerline.sh"\
>> ~/.bashrc

RUN echo "{\n\
    \"ext\": {\n\
        \"shell\": {\n\
            \"theme\": \"default_leftonly\"\n\
        }\n\
    }\n\
}"\
>> ~/.config/powerline/config.json


# RUN powerline-daemon --replace

# COPY . .

# docker run --name pg-0 -e POSTGRES_PASSWORD=1234 -d postgres:12.3
# docker exec -ti pg-0 /bin/bash

ARG GIT_USER_EMAIL
ARG GIT_USER_NAME
ARG IMAGE_VERSION

# git config add
RUN git config --global user.email $GIT_USER_EMAIL
RUN git config --global user.name $GIT_USER_NAME

EXPOSE 5432

#ADD IMAGE_VERSION /tmp/bustcache

RUN cd /usr/src && git clone https://github.com/hazardland/hook.pg.git ./hooks
RUN cat /usr/src/hooks/gitconfig >> ~/.gitconfig

# SERVER
RUN mkdir -p /usr/src/server && cd /usr/src/server && git init && git config core.hooksPath ../hooks/branch && touch .gitignore && echo ".commit" >> .gitignore && git add . && git commit -am "init"

# DEV
RUN mkdir -p /usr/src/project && cd /usr/src/project && git init && git config core.hooksPath ../hooks/dev && git remote add origin /usr/src/server/.git && git pull origin master


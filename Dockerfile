FROM ubuntu:22.04

LABEL "name"="Hugo rsync deployment"
LABEL "maintainer"="Ron van der Heijden <r.heijden@live.nl>"
LABEL "version"="0.1.6"

LABEL "com.github.actions.name"="Hugo rsync deployment"
LABEL "com.github.actions.description"="An action that generates and deploys a static website using Hugo and rsync."
LABEL "com.github.actions.icon"="upload-cloud"
LABEL "com.github.actions.color"="blue"

LABEL "repository"="https://github.com/maciasgarcia/hugo-rsync-deployment"
LABEL "homepage"="https://ronvanderheijden.nl/"

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y hugo \
                       rsync \
                       curl 

                   
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - &&\
        apt-get install -y nodejs


ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

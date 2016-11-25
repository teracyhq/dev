FROM python:2.7

LABEL authors="hoatle <hoatle@teracy.com>"

RUN useradd --user-group --create-home --shell /bin/false app && mkdir -p /opt/app

ENV HOME=/home/app TERM=xterm-256color APP=/opt/app

# add more arguments from CI to the image so that `$ env` should reveal more info
ARG CI_BUILD_ID
ARG CI_BUILD_REF
ARG CI_REGISTRY_IMAGE
ARG CI_PROJECT_NAME
ARG CI_BUILD_REF_NAME
ARG CI_BUILD_TIME

ENV CI_BUILD_ID=$CI_BUILD_ID CI_BUILD_REF=$CI_BUILD_REF CI_REGISTRY_IMAGE=$CI_REGISTRY_IMAGE \
    CI_PROJECT_NAME=$CI_PROJECT_NAME CI_BUILD_REF_NAME=$CI_BUILD_REF_NAME CI_BUILD_TIME=$CI_BUILD_TIME

ADD requirements.txt $APP/

RUN chown -R app $APP && chgrp -R app $APP \
    && chown -R app /usr/local

WORKDIR $APP

USER app

RUN pip install --global pip

RUN pip install -r requirements.txt

CMD ["make", "generate"]

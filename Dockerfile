FROM lsiobase/guacgui

# set version label
ARG BUILD_DATE
ARG VERSION
# ARG CALIBRE_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="ssnarf"

ENV APPNAME="MediaMonkey" UMASK_SET="022"

RUN \
 echo "**** install runtime packages ****" \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        cabextract \
        git \
        gosu \
        gpg-agent \
        p7zip \
        software-properties-common \
        tzdata \
        unzip \
        wget \
        winbind \
        xvfb \
        zenity \
    && rm -rf /var/lib/apt/lists/*

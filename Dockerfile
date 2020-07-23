FROM lsiobase/guacgui

# set version label
ARG BUILD_DATE
ARG VERSION
# ARG CALIBRE_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="ssnarf"

ENV APPNAME="MediaMonkey" UMASK_SET="022"

RUN \
 echo "**** Add 32bit arch ****" \
 && dpkg --add-architecture i386 \
 
 && echo "**** Add wine and faudio (needed in 18.04) repos ****" \
 && wget -O - https://dl.winehq.org/wine-builds/winehq.key | apt-key add - \
 && add-apt-repository -y 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main' \
 && add-apt-repository -y ppa:cybermax-dexter/sdl2-backport # requires input \
 
 && echo "**** install runtime packages ****" \
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
        winehq-stable \
        winetricks \
        xvfb \
        zenity \
    && rm -rf /var/lib/apt/lists/* \
    
  && echo "**** get ie8 to resolve OLE errors ****" \
  && winetricks -q ie8 \
  
  && echo "**** download latest mmw installer (beware 302 redirect) ****" \
  && mkdir /opt/mmw \
  && wget -O /opt/mmw/mmwsetup.exe https://www.mediamonkey.com/MediaMonkey_Setup.exe

FROM lsiobase/guacgui

# set version label
ARG BUILD_DATE
ARG VERSION
# ARG CALIBRE_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="ssnarf"

ENV APPNAME="MediaMonkey" UMASK_SET="022"

RUN addgroup --system xusers \
  && adduser \
			--home /home/xclient \
			--disabled-password \
			--shell /bin/bash \
			--gecos "user for running an xclient application" \
			--ingroup xusers \
			--quiet \
			xclient

# Base package install 
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		gnupg2 \
		software-properties-common \
		unzip \
		wget \
		ca-certificates \
		nano

# Wine install
RUN \
 dpkg --add-architecture i386 \
 && wget -O - https://dl.winehq.org/wine-builds/winehq.key | apt-key add - \
 && add-apt-repository -y 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main' \
 && add-apt-repository -y ppa:cybermax-dexter/sdl2-backport \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
        winehq-stable \
        winetricks

# Clean up
RUN \
  rm -rf /var/lib/apt/lists/*
 
# Install IE8 to resolve OLE errors
# RUN \
#  winetricks -q ie8

# Wine really doesn't like to be run as root, so let's use a non-root user
# USER xclient
#ENV HOME /home/xclient
#ENV WINEPREFIX /home/xclient/.wine
#ENV WINEARCH win32

# Use xclient's home dir as working dir
# WORKDIR /home/xclient

# Download latest mmw installer (beware 302 redirect)
RUN \
 mkdir -p /home/xclient/mmw \
 && wget -O /home/xclient/mmw/mmwsetup.exe https://www.mediamonkey.com/MediaMonkey_Setup.exe

# Switch back to root user
# USER root

FROM rocker/tidyverse:latest
MAINTAINER Trang Le grixor@gmail.com

COPY DESCRIPTION install.sh /pkg/

RUN cd /pkg && ./install.sh

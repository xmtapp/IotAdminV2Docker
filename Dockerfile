FROM ubuntu:16.04

MAINTAINER Dong Yao <dong_yao_cn@163.com>

RUN cp /etc/apt/sources.list /etc/apt/sources.list_backup

ADD ./sources.list /etc/apt/sources.list

RUN apt-get clean && apt-get update && apt-get install -y locales
RUN apt upgrade -y

ADD ./locale /etc/default/locale
RUN locale-gen zh_CN.UTF-8
ENV LANG zh_CN.UTF-8
ENV LANGUAGE zh_CN:zh
ENV LC_ALL zh_CN.UTF-8

RUN apt install -y python-software-properties software-properties-common
RUN add-apt-repository ppa:certbot/certbot
RUN add-apt-repository ppa:ondrej/php
RUN apt update
RUN apt install -y certbot python-certbot-nginx php7.1 php7.1-cli php7.1-fpm php7.1-gd php7.1-json php7.1-mysql php7.1-readline php7.1-xml php7.1-mbstring php7.1-curl php7.1-zip php7.1-bcmath composer supervisor nginx redis-server npm memcached expect


# 清理apt缓存
RUN apt-get clean
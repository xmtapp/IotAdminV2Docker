FROM ubuntu:16.04

MAINTAINER Dong Yao <dong_yao_cn@163.com>

COPY ./sources.list /etc/apt/sources.list.d/aliyun.list

RUN apt-get clean && apt-get update && apt-get install -y locales vim zsh && apt upgrade -y

ADD ./locale /etc/default/locale
RUN locale-gen zh_CN.UTF-8
ENV LANG zh_CN.UTF-8
ENV LANGUAGE zh_CN:zh
ENV LC_ALL zh_CN.UTF-8

RUN apt install -y python-software-properties software-properties-common
RUN add-apt-repository ppa:certbot/certbot \
    && add-apt-repository ppa:ondrej/php \
    && apt update \
    && apt install -y certbot python-certbot-nginx php7.1 php7.1-cli php7.1-fpm php7.1-gd php7.1-json php7.1-mysql php7.1-readline php7.1-xml php7.1-mbstring php7.1-curl php7.1-zip php7.1-bcmath composer supervisor nginx redis-server npm memcached expect

# 安装mysql
RUN { \
        echo mysql-server-5.7 mysql-server/root_password password 'admin@!@#'; \
        echo mysql-server-5.7 mysql-server/root_password_again password 'admin@!@#'; \
    } | debconf-set-selections \
    && apt install mysql-client-core-5.7 mysql-client-5.7  mysql-server-5.7 -y

# comment out a few problematic configuration values
# don't reverse lookup hostnames, they are usually another container
RUN sed -Ei 's/^(bind-address|log)/#&/' /etc/mysql/mysql.conf.d/mysqld.cnf \
    && echo '[mysqld]\nskip-host-cache\nskip-name-resolve' > /etc/mysql/conf.d/docker.cnf

RUN systemctl enable mysql

COPY setup.sh /home/setup.sh


# 清理apt缓存
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/bin/bash", "/home/setup.sh"]


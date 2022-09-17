#!/bin/bash

cat << EOF
ARG RUBY_VERSION=$RUBY_VERSION
FROM ruby:\$RUBY_VERSION

ARG BUNDLER_VERSION=$(bundler --version | sed -E 's/^Bundler version (.+)$/\1/')
RUN gem install bundler -v \$BUNDLER_VERSION

# freetds for sqlserver - remove if unneeded
# https://github.com/rails-sqlserver/tiny_tds
ARG FREETDS_VERSION=1.3.13
RUN wget http://www.freetds.org/files/stable/freetds-\${FREETDS_VERSION}.tar.gz && \\
  tar -xzf freetds-\${FREETDS_VERSION}.tar.gz && \\
  cd freetds-\${FREETDS_VERSION} && \\
  ./configure --prefix=/usr/local --with-tdsver=7.3 && \\
  make && \\
  make install && \\
  cd .. && \\
  rm -rf freetds-*

#
# app user - sudoer for bundle install
# https://thelurkingvariable.com/2019/12/17/ruby-with-docker-compose-as-a-non-root-user/
#
ARG USER=$(id -nu)
ARG UID=$(id -u)
ARG GID=\$UID
RUN apt update && apt install -y sudo
RUN groupadd -g \$GID \$USER && \\
  useradd -lm -u \$UID -g \$GID \$USER && \\
  echo \$USER ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/\$USER && \\
  chmod 0440 /etc/sudoers.d/\$USER

USER \$USER

WORKDIR /app

CMD /bin/sh -c "while sleep 1000; do :; done"
EOF

#!/bin/bash

cat << EOF
ARG RUBY_VERSION=$RUBY_VERSION
FROM ruby:\$RUBY_VERSION

ARG BUNDLER_VERSION=$(bundler --version | sed -E 's/^Bundler version (.+)$/\1/')
RUN gem install bundler -v \$BUNDLER_VERSION

# freetds for sqlserver - remove if unneeded
RUN apt-get update && apt-get install -y freetds-dev freetds-bin

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

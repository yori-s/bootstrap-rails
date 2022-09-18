ARG RUBY_VERSION=3.0.4
FROM ruby:$RUBY_VERSION

# freetds - dont like bundle install complaining in case sqlserver is selected
RUN apt-get update && apt-get install -y freetds-dev freetds-bin

ARG BUNDLER_VERSION=2.3.22
RUN gem install bundler -v $BUNDLER_VERSION

ARG RAILS_VERSION=7.0.4
RUN gem install rails -v $RAILS_VERSION

#
# app user - sudoer for bundle install
# https://thelurkingvariable.com/2019/12/17/ruby-with-docker-compose-as-a-non-root-user/
#
ARG USER=rails
ARG UID=1000
ARG GID=$UID
RUN apt update && apt install -y sudo
RUN groupadd -g $GID $USER && \
  useradd -lm -u $UID -g $GID $USER && \
  echo $USER ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USER && \
  chmod 0440 /etc/sudoers.d/$USER

USER $USER

WORKDIR /tgt
WORKDIR /src
COPY --chown=$USER *.sh ./
RUN chmod +x *.sh

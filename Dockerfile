ARG RUBY_VERSION=3.0.4
FROM ruby:$RUBY_VERSION

# freetds - dont like bundle install complaining in case sqlserver is selected
# https://github.com/rails-sqlserver/tiny_tds
ARG FREETDS_VERSION=1.3.13
RUN wget http://www.freetds.org/files/stable/freetds-${FREETDS_VERSION}.tar.gz && \
  tar -xzf freetds-${FREETDS_VERSION}.tar.gz && \
  cd freetds-${FREETDS_VERSION} && \
  ./configure --prefix=/usr/local --with-tdsver=7.3 && \
  make && \
  make install && \
  cd .. && \
  rm -rf freetds-*

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

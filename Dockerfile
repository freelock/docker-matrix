FROM debian:jessie

# Maintainer
MAINTAINER John Locke <john@freelock.com>

# update and upgrade
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update -y \
    && apt-get install -y build-essential \
      python2.7-dev \
      libffi-dev \
      python-pip \
      python-setuptools \
      sqlite3 \
      libssl-dev \
      python-virtualenv \
      libjpeg-dev \
      git-core \
      subversion \
      libevent-dev \
      libsqlite3-dev \
      pwgen

# Install main Synapse package
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y software-properties-common curl \
    && add-apt-repository -y "http://matrix.org/packages/debian/ main" \
    && curl http://matrix.org/packages/debian/repo-key.asc | apt-key add - \
    && apt-get update -y \
    && apt-get install -y matrix-synapse \
      matrix-synapse-angular-client

# install homerserver template
COPY adds/start.sh /start.sh
RUN chmod a+x /start.sh

# startup configuration
CMD ["/start.sh", "start"]
EXPOSE 8448
VOLUME ["/data"]

# install synapse homeserver
# RUN git clone https://github.com/matrix-org/synapse /tmp-synapse

# RUN cd /tmp-synapse \
#    && git pull \
#    && git describe --always --long | tee /synapse.version
# RUN pip install --process-dependency-links /tmp-synapse

# install turn-server
RUN svn co http://coturn.googlecode.com/svn/trunk coturn \
    && cd coturn \
    && ./configure \
    && make \
    && make install

RUN pip install 'https://github.com/matrix-org/matrix-angular-sdk/tarball/v0.6.6/#egg=matrix_angular_sdk-0.6.6'

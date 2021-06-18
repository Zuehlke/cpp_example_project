# =================================
# Build and test environment for CI
# =================================

FROM ubuntu:20.04 as cpp-docker-ci

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y dist-upgrade && apt-get -y install --fix-missing \
  binutils \
  build-essential \
  bzip2 \
  clang-format \
  cmake \
  python \
  python3-pip \
  ssh \
  sudo \
  tar \
  && apt-get autoremove -y && apt-get clean






# =================================
# DEV environment for local machine
# =================================

FROM cpp-docker-ci as cpp-docker-dev

ARG DEV_USER=dev

RUN apt-get -y install --fix-missing \
  ccache \
  curl \
  shellcheck \
  valgrind \
  vim \
  && apt-get autoremove -y && apt-get clean

# Dev user for inside the container
RUN groupadd -g 1000 ${DEV_USER} && \
  useradd -m -u 1000 -g 1000 -d /home/${DEV_USER} -s /bin/bash ${DEV_USER} && \
  usermod -a -G adm,cdrom,sudo,dip,plugdev ${DEV_USER} && \
  echo "${DEV_USER}:${DEV_USER}" | chpasswd && \
  echo "${DEV_USER}   ALL=(ALL:ALL) ALL" >> /etc/sudoers

# fix "Missing privilege separation directory" error in SSHD
# see: https://bugs.launchpad.net/ubuntu/+source/openssh/+bug/45234
RUN mkdir /var/run/sshd && chmod 0755 /var/run/sshd

COPY ccache.conf /etc/.

USER ${DEV_USER}
WORKDIR /home/${DEV_USER}

RUN sed -i 's/\\h/docker/;s/01;32m/01;33m/' /home/${DEV_USER}/.bashrc \
  && mkdir /home/${DEV_USER}/git

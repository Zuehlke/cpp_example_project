# =================================
# Build and test environment for CI
# =================================

FROM ubuntu:20.04 as cpp-docker-ci

ARG DEBIAN_FRONTEND=noninteractive
ARG CLANG_VERSION=12

RUN apt-get update && apt-get -y dist-upgrade
RUN apt-get -y install --fix-missing \
  build-essential \
  bzip2 \
  ccache \
  clang-format \
  cmake \
  cppcheck \
  curl \
  doxygen \
  git \
  graphviz \
  lsb-release \
  ninja-build \
  python3 \
  python3-pip \
  shellcheck \
  software-properties-common \
  ssh \
  sudo \
  tar \
  wget
RUN wget https://apt.llvm.org/llvm.sh && chmod +x llvm.sh && ./llvm.sh ${CLANG_VERSION}
RUN apt-get -y install clang-tidy-${CLANG_VERSION}
RUN pip3 install conan
RUN apt-get autoremove -y && apt-get clean
RUN echo $(which conan) > /etc/conan.which

# fix "Missing privilege separation directory":
# https://bugs.launchpad.net/ubuntu/+source/openssh/+bug/45234
RUN mkdir /run/sshd

# =================================
# DEV environment for local machine
# =================================

FROM cpp-docker-ci as cpp-docker-dev

ARG DEV_USER=dev

RUN apt-get -y install --fix-missing \
  ccache \
  curl \
  doxygen \
  graphviz \
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


USER ${DEV_USER}
WORKDIR /home/${DEV_USER}

RUN sed -i 's/\\h/docker/;s/01;32m/01;33m/' /home/${DEV_USER}/.bashrc \
  && mkdir /home/${DEV_USER}/git

# =================================
# Build and test environment for CI
# =================================

FROM ubuntu:22.10 as cpp-docker-common

ARG DEBIAN_FRONTEND=noninteractive
ENV PATH="${PATH}:/cmake-3.26.3-linux-x86_64/bin/:"

RUN apt-get update && apt-get -y dist-upgrade && apt-get -y install --fix-missing \
  apturl \
  binutils \
  build-essential \
  bzip2 \
  cppcheck \
  ccache \
  doxygen \
  graphviz \
  lsb-release \
  ninja-build \
  python3 \
  python3-pip \
  shellcheck \
  ssh \
  software-properties-common \
  sudo \
  tar \
  valgrind \
  wget
RUN wget https://github.com/Kitware/CMake/releases/download/v3.26.3/cmake-3.26.3-linux-x86_64.sh  \
    && chmod +x cmake-3.26.3-linux-x86_64.sh  \
    && ./cmake-3.26.3-linux-x86_64.sh --include-subdir --skip-license \
    && rm cmake-3.26.3-linux-x86_64.sh
RUN bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"
RUN apt-get -y install clang-format clang-tidy clang-15
RUN apt-get autoremove -y && apt-get clean


# =================================
# DEV environment for local machine
# =================================

FROM cpp-docker-common as cpp-docker-dev

ARG DEV_USER=dev
ENV PATH="${PATH}:/home/${DEV_USER}/.local/bin/"

RUN apt-get -y install --fix-missing vim \
    && apt-get autoremove -y && apt-get clean

# Dev user for inside the container
RUN groupadd -g 1000 ${DEV_USER} && \
  useradd -m -u 1000 -g 1000 -d /home/${DEV_USER} -s /bin/bash ${DEV_USER} && \
  usermod -a -G adm,cdrom,sudo,dip,plugdev ${DEV_USER} && \
  echo "${DEV_USER}:${DEV_USER}" | chpasswd && \
  echo "${DEV_USER}   ALL=(ALL:ALL) ALL" >> /etc/sudoers

# fix "Missing privilege separation directory" error in SSHD
# see: https://bugs.launchpad.net/ubuntu/+source/openssh/+bug/45234
RUN chmod 0755 /var/run/sshd

COPY ccache.conf /etc/.

USER ${DEV_USER}
WORKDIR /home/${DEV_USER}

RUN sed -i 's/\\h/docker/;s/01;32m/01;33m/' /home/${DEV_USER}/.bashrc \
  && mkdir /home/${DEV_USER}/git

RUN pip install --user conan==1.59


FROM cpp-docker-common as cpp-docker-ci

ARG CI_USER=ci
ENV PATH="${PATH}:/home/${CI_USER}/.local/bin/"

# Dev user for inside the container
RUN groupadd -g 1000 ${CI_USER} && \
  useradd -m -u 1000 -g 1000 -d /home/${CI_USER} -s /bin/bash ${CI_USER} && \
  usermod -a -G adm,cdrom,sudo,dip,plugdev ${CI_USER} && \
  echo "${CI_USER}:${CI_USER}" | chpasswd && \
  echo "${CI_USER}   ALL=(ALL:ALL) ALL" >> /etc/sudoers

COPY ccache.conf /etc/.
USER ${CI_USER}
RUN pip install conan==1.59
WORKDIR /home/${CI_USER}

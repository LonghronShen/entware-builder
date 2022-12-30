FROM longhronshens/busybox AS builder

ARG SHA
ARG ENTWARE_ARCH=x64-k3.2

ENV SHA=${SHA}
ENV ENTWARE_ARCH=${ENTWARE_ARCH}

RUN mkdir -p /opt && chmod 600 /opt && \
    cd /opt && wget http://bin.entware.net/${ENTWARE_ARCH}/installer/generic.sh && \
    sh ./generic.sh && \
    echo "export PATH=/opt/bin:/opt/sbin:\$PATH" > /etc/profile && \
    source /etc/profile

ENV PATH="/opt/bin:/opt/sbin:${PATH}"

RUN opkg install --force-overwrite make automake bash busybox \
        cmake coreutils coreutils-chgrp coreutils-chown coreutils-install \
        diffutils gcc git git git-http htop icu \
        ldconfig ldd libintl-full libopenssl libopenssl-conf \
        libpcre2 libevent2-openssl libcurl libtool-bin \
        net-tools openssh-client-utils \
        openssh-keygen openssh-moduli openssh-sftp-client \
        patch pkg-config python3-pip python3-setuptools \
        rsync screen shadow tar wget && \
    opkg install boost boost-atomic boost-chrono boost-container \
        boost-context boost-contract boost-coroutine boost-date_time \
        boost-fiber boost-filesystem boost-graph boost-iostreams boost-json \
        boost-locale boost-log boost-math boost-nowide boost-program_options \
        boost-python3 boost-random boost-regex boost-serialization \
        boost-stacktrace boost-system boost-test boost-thread boost-timer \
        boost-type_erasure boost-wave boost-wserialization

RUN opkg install libatomic || true

RUN /opt/bin/busybox wget -qO- "$(/opt/bin/busybox sed -Ene \
  's|^src/gz[[:space:]]entware[[:space:]]https?([[:graph:]]+)|http\1/include/include.tar.gz|p' \
  /opt/etc/opkg.conf)" | /opt/bin/busybox tar x -vzC /opt/include

WORKDIR /tmp

COPY scripts/install_ninja.sh install_ninja.sh
COPY scripts/install_nproc.sh install_nproc.sh
COPY scripts/liblinks.sh liblinks.sh

RUN /opt/bin/bash install_ninja.sh && \
  /opt/bin/bash install_nproc.sh && \
  /opt/bin/bash liblinks.sh /opt/lib && \
  rm *.sh && \
  ldconfig && ldconfig -v

WORKDIR /app

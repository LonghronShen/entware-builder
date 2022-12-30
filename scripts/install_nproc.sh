#!/opt/bin/bash

set -x

hash nproc 2>/dev/null || {
    echo "Build nproc from source ..."
    mkdir -p /opt/tmp

    cd /opt/tmp

    git clone --depth=1 https://github.com/LonghronShen/container_cpu_detection.git

    cd ./container_cpu_detection

    mkdir build/
    cd build
    cmake ..
    cmake --build .
    mv ./bin/sysconf_test ./bin/nproc
    install -Dm0755 -t /opt/bin ./bin/nproc

    cd /opt/tmp
    rm -rf /opt/tmp/container_cpu_detection
}

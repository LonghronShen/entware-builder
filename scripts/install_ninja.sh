#!/opt/bin/bash

set -x

mkdir -p /opt/tmp

cd /opt/tmp

git clone https://github.com/ninja-build/ninja.git

cd ./ninja

git checkout release

mkdir build/
cmake ..
cmake --build .
install -Dm0755 -t /opt/bin ./ninja

cd /opt/tmp
rm -rf /opt/tmp/ninja
#!/bin/sh

set -e

wget https://github.com/jedisct1/libsodium/releases/download/1.0.11/libsodium-1.0.11.tar.gz
tar xvfz libsodium-1.0.11.tar.gz
cd libsodium-1.0.11
./configure
make
make install

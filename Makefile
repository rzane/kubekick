VERSION=$(shell cat VERSION)
SOURCES=$(wildcard src/*.cr src/**/*.cr)
DOWNLOAD=https://github.com/rzane/kubekick/archive/v$(VERSION).zip
SHA256=$(shell openssl sha256 < archive.zip)

OS := $(shell uname -s | tr '[:upper:]' '[:lower:]')
ARCH := $(shell uname -m)

ifeq ($(OS),linux)
	CRFLAGS := --link-flags "-static -L/opt/crystal/embedded/lib"
endif

ifeq ($(OS),darwin)
	CRFLAGS := --link-flags "-L$(PWD)/.static"
endif

all: deps build

deps:
	crystal deps --production

build:
	if [ "$(OS)" = "darwin" ] ; then \
		mkdir -p .static;\
	  cp /usr/local/lib/libyaml.a .static ;\
		cp /usr/local/lib/libsodium.a .static ;\
		cp /usr/local/lib/libpcre.a .static ;\
		cp /usr/local/lib/libevent.a .static ;\
		cp /usr/local/lib/libiconv.a .static ;\
		cp /usr/local/opt/bdw-gc/lib/libgc.a .static ;\
	fi
	crystal build --release -o bin/kubekick src/kubekick.cr $(CRFLAGS)
	gzip -c bin/kubekick > kubekick-$(VERSION)_$(OS)_$(ARCH).gz

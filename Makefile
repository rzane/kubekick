VERSION := $(shell cat VERSION)
OS := $(shell uname -s | tr '[:upper:]' '[:lower:]')
ARCH := $(shell uname -m)

ifeq ($(OS),linux)
	CRFLAGS := --link-flags "-static -L/opt/crystal/embedded/lib"
endif

ifeq ($(OS),darwin)
	CRFLAGS := --link-flags "-L$(PWD)/.static"
	PREBUILD := copy-libraries
endif

all: deps build

copy-libraries:
	rm -rf .static
	mkdir .static
	cp /usr/local/lib/libyaml.a .static
	cp /usr/local/lib/libsodium.a .static
	cp /usr/local/lib/libpcre.a .static
	cp /usr/local/lib/libevent.a .static
	cp /usr/local/lib/libgc.a .static

deps:
	crystal deps --production

test:
	crystal spec

release: $(PREBUILD)
	crystal build --release -o bin/kubekick src/kubekick.cr $(CRFLAGS)
	tar zcvf kubekick-$(VERSION)_$(OS)_$(ARCH).tar.gz bin/kubekick

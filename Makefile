VERSION := $(shell cat VERSION)
OS := $(shell uname -s | tr '[:upper:]' '[:lower:]')
ARCH := $(shell uname -m)
ARCHIVE := kubekick-$(VERSION)_$(OS)_$(ARCH).tar.gz

ifeq ($(OS),linux)
	CRFLAGS := --static
endif

ifeq ($(OS),darwin)
	CRFLAGS := --link-flags "-L$(PWD)/.static"
	PREBUILD := darwin-copy-static
endif

all: deps release

darwin-copy-static:
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
	crystal build -o bin/kubekick src/kubekick.cr --release $(CRFLAGS)
	tar zcvf $(ARCHIVE) bin/kubekick

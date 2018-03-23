VERSION := $(shell cat VERSION)
OS := $(shell uname -s | tr '[:upper:]' '[:lower:]')
ARCH := $(shell uname -m)
SOURCES := $(wildcard src/*.cr src/**/*.cr)

all: bin/kubekick

bin/kubekick: $(SOURCES)
	mkdir -p bin
	crystal deps --production
	crystal build -o bin/kubekick src/kubekick.cr --release

release: all
	gzip -c bin/kubekick > kubekick-$(VERSION)_$(OS)_$(ARCH).gz

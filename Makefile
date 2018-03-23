VERSION=$(shell cat VERSION)
SOURCES=$(wildcard src/*.cr src/**/*.cr)
DOWNLOAD=https://github.com/rzane/kubekick/archive/v$(VERSION).zip
SHA256=$(shell openssl sha256 < archive.zip)

all: bin/kubekick

bin/kubekick: $(SOURCES)
	mkdir -p bin
	crystal deps --production
	crystal build -o bin/kubekick src/kubekick.cr --release

release.tag:
	git tag v$(VERSION)
	git push --tags

release.brew:
	wget -q -O archive.zip $(DOWNLOAD)
	perl -pe 's|url ".*"|url "$(DOWNLOAD)"|g' -i kubekick.rb
	perl -pe 's|sha256 ".*"|sha256 "$(SHA256)"|g' -i kubekick.rb
	rm -rf archive.zip

release: release.tag release.brew

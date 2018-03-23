all: bin/kubekick

bin/kubekick:
	mkdir -p bin
	crystal deps --production
	crystal build -o bin/kubekick src/kubekick.cr --release


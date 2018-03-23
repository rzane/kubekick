all: bin/kubekick

bin/kubekick:
	crystal deps --production
	crystal build -o bin/kubekick src/kubekick.cr --release



build:
	jbuilder build

serve: build
	./_build/default/bin/main.exe

docker:
	docker build -t burgerdev/testserver:latest .

.PHONY: build serve

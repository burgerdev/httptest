
build:
	jbuilder build

serve: build
	./_build/default/bin/main.exe

docker:
	docker build -t burgerdev/testserver:latest .

docker-serve: docker
	docker run -it --rm -p 8080:8080 burgerdev/testserver:latest

.PHONY: build serve docker docker-serve

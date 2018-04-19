
build:
	jbuilder build

serve: build
	./_build/default/bin/main.exe

.PHONY: build serve

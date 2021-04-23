all: build run

build:
	docker build . -t xwcl/milk-carton

force-build:
	docker build --no-cache . -t xwcl/milk-carton

push:
	docker push xwcl/milk-carton

run: build
	mkdir -p ./work
	docker run -v /var/run/docker.sock:/var/run/docker.sock -v $(PWD)/work:/work -it xwcl/milk-carton bash -l

.PHONY: all build force-build push run

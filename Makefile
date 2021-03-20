all: build run

build:
	docker build . -t xwcl/milk-carton

force-build:
	docker build --no-cache . -t xwcl/milk-carton

push:
	docker push

run: build
	docker run -v $(PWD)/work:/work -it xwcl/milk-carton bash -l

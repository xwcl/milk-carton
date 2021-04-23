# `milk-carton`: containers for [MILK](https://github.com/milk-org/milk)

Tested with `milk-org/milk@c33ef1d95fbbb8121009780766ae12162d819e05`.

## Run the container

Is the published one good enough? Maybe you don't need to build anything.

```
$ docker pull xwcl/milk-carton
$ docker run -it xwcl/milk-carton
milkuser@5809351ea9d5:/work$ which milk
```

## Build (& run) the container

```
$ make
```

## Publish the build

```
$ make push
```

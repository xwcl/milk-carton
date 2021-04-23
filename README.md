# `milk-carton`: containers for [MILK](https://github.com/milk-org/milk)

Tested with `milk-org/milk@c33ef1d95fbbb8121009780766ae12162d819e05`.

## Run the container

Is the published one good enough? Maybe you don't need to build anything.

The following shows how to pull `xwcl/milk-carton`, map `./work` to `/work` inside the container, and run as an unprivileged user named `milkuser` (that only exists in the container). Files created by this user will be owned by the `docker` group (Linux) or your user account (macOS).

```
$ docker pull xwcl/milk-carton
$ mkdir work
$ docker run -v /var/run/docker.sock:/var/run/docker.sock -v $PWD/work:/work -it xwcl/milk-carton
milkuser@3c8b672d7cb9:/work$ which milk
/usr/local/milk/bin/milk
milkuser@3c8b672d7cb9:/work$ exit
$
```

If you **don't** expose the `/var/run/docker.sock` socket, you get `root` in the container:

```
$ docker run -v $PWD/work:/work -it xwcl/milk-carton
root@3c8b672d7cb9:/work$
```

This is generally not recommended, but you're running this on your own computer. You're the boss.

## Build (& run) the container

```
$ make
```

## Publish the build

```
$ make push
```

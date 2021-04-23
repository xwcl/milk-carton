# `milk-carton`: containers for [MILK](https://github.com/milk-org/milk)

Tested with `milk-org/milk@c33ef1d95fbbb8121009780766ae12162d819e05`.

## Run the container

Is the published one good enough? Maybe you don't need to build anything.

The following shows how to pull `xwcl/milk-carton`, map `./work` to `/work` inside the container, and run as an unprivileged user named `milkuser` (that only exists in the container).

```
$ docker pull xwcl/milk-carton
$ mkdir work
$ docker run -v $PWD/work:/work -it xwcl/milk-carton
milkuser@3c8b672d7cb9:/work$ which milk
/usr/local/milk/bin/milk
milkuser@3c8b672d7cb9:/work$ exit
$
```

If you write files to `/work` from the container, they'll show up on the host side as expected, with the same owner and group as the host-side `./work` directory.

## Build the container

Just:

```
$ make build
```

Build and run?

```
$ make
```

Something caching that shouldn't?

```
$ make force-build
```

## Publish the build

You need to be logged in to DockerHub, and a member of the `xwcl` organization first, but then it's just:

```
$ make push
```

## What's with this `entrypoint.sh` thing?

Yeah, so, we need to be able to write files to `/work` in the container and have them be accessible from outside. When using macOS, Docker for Mac transparently rewrites file ownership information. So when `milkuser` makes a file in `/work`, the `./work` directory gets a file owned by your own personal user account.

On Docker's native Linux, it's a different story. Ownership is just a numeric ID, and the container IDs may not match the host IDs at all. Docker passes them right through unmodified. So, when `milkuser` creates a file, it would normally be owned by user `1000` on the host. Might be you, might be someone else. Clearly not ideal.

What `entrypoint.sh` does is make sure that the IDs of the `/work` directory's owner and group are the same, numerically, as the `milkuser` user and `milkuser` group IDs. That way, when you create a file in the `/work` directory of the container, it comes out with the right ownership on the other side. (Provided, of course, you're using a directory you own as the target for the `/work` mount.)

On the plus side, when using Singularity, none of this matters.

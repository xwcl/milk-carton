#!/bin/bash
# based on https://github.com/sudo-bmitch/jenkins-docker/blob/main/entrypoint.sh
UNPRIV_USER=milkuser
MILK_ROOT=/build
MILK_INSTALLDIR=/usr/local/milk
PATH="${PATH}:${MILK_INSTALLDIR}/bin"
PKG_CONFIG_PATH="$PKG_CONFIG_PATH:${MILK_INSTALLDIR}/lib/pkgconfig"
preserve_vars="--preserve-env=MILK_ROOT,MILK_INSTALLDIR,PATH,PKG_CONFIG_PATH"
if [[ "$(id -u)" = "0" && -e /var/run/docker.sock ]]; then
  # get gid of docker socket file
  SOCK_DOCKER_GID=`ls -ng /var/run/docker.sock | cut -f3 -d' '`

  # get group of docker inside container
  CUR_DOCKER_GID=`getent group docker | cut -f3 -d: || true`

  # if they don't match, adjust
  if [ ! -z "$SOCK_DOCKER_GID" -a "$SOCK_DOCKER_GID" != "$CUR_DOCKER_GID" ]; then
    groupmod -g ${SOCK_DOCKER_GID} -o docker
  fi
  if ! groups $UNPRIV_USER | grep -q docker; then
    usermod -aG docker $UNPRIV_USER
  fi

  if [[ "$#" == 0 ]]; then
    exec sudo $preserve_vars -u $UNPRIV_USER -g docker bash -l
  else
    exec sudo $preserve_vars -u $UNPRIV_USER -g docker "$@"
  fi
fi

# not root? great let's become a login shell (or whatever)
exec "$@"

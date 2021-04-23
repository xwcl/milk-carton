#!/bin/bash

# Configure environment variables for milk
MILK_ROOT=/build
MILK_INSTALLDIR=/usr/local/milk
PATH="${PATH}:${MILK_INSTALLDIR}/bin"
PKG_CONFIG_PATH="$PKG_CONFIG_PATH:${MILK_INSTALLDIR}/lib/pkgconfig"
# tell sudo we really do want to pass them along when we drop privileges
KEEP_VARS="MILK_ROOT,MILK_INSTALLDIR,PATH,PKG_CONFIG_PATH"
# our unprivileged user account
UNPRIV_USER=milkuser

if [[ "$(id -u)" = "0" ]]; then
  WORK_GID=$(stat -c "%g" /work)
  if [[ $WORK_GID != 0 ]]; then  # don't transform *into* root...
    groupmod -g ${WORK_GID} -o $UNPRIV_USER
  fi
  WORK_UID=$(stat -c "%u" /work)
  if [[ $WORK_UID != 0 ]]; then # don't transform *into* root...
    usermod -u ${WORK_UID} -o $UNPRIV_USER
  fi

  if [[ "$#" == 0 ]]; then
    exec sudo --preserve-env=$KEEP_VARS -u $UNPRIV_USER bash -l
  else
    exec sudo --preserve-env=$KEEP_VARS -u $UNPRIV_USER "$@"
  fi
fi

# not root? great, let's become a login shell (or whatever)
if [[ "$#" == 0 ]]; then
  exec bash -l
else
  exec "$@"
fi

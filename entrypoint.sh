#!/bin/bash

function shutdown() {
  /etc/init.d/sendsigs stop
}
trap shutdown EXIT

puppet apply /etc/puppet/manifests

if [ -z "$1" ] ; then
  tail -f /dev/null
else
  $*
fi


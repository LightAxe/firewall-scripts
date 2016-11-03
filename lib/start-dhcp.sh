#!/bin/bash
# Turns on a dhcp server

IF=""

while getopts ":i:h?" opt; do
  case $opt in
    :|\?|h)
      echo "Usage: ${0} -i INTERFACE"
      ;;
    i)
      IF=${OPTARG}
      ;;
  esac
done

if [[ -z "${IF}" ]]; then
  echo "Usage: ${0} -i INTERFACE"
  exit 1
fi

#Do stuff, know things

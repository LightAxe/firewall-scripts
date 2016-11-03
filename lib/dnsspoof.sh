#!/bin/bash
# Builds a zone file for the spoofed domain

HOST=""

while getopts ":s:h?" opt; do
  case $opt in
    :|\?|h)
      echo "Usage: ${0} -s HOSTNAME"
      ;;
    s)
      HOST=${OPTARG}
      ;;
  esac
done

if [[ -z "${HOST}" ]]; then
  echo "Usage: ${0} -s HOSTNAME"
  exit 1
fi

#Do stuff, know things

#!/bin/bash
# Opens traffic between the downstream and upstream interfaces
# to the specified server and port

# NOTE:  I think we can get this working just specifying the right
# chain, but we *may* need to include the interface names.  TBD.

HOST=""
PORT=""

while getopts ":s:p:h?" opt; do
  case $opt in
    :|\?|h)
      echo "Usage: ${0} -s SERVER -p PORT"
      ;;
    s)
      HOST=${OPTARG}
      ;;
    p)
      PORT=${OPTARG}
      ;;
  esac
done

if [[ -z "${HOST}" ]] || [[ -z "${PORT} ]]; then
  echo "Usage: ${0} -s SERVER -p PORT"
  exit 1
fi

#Do stuff, know things

#!/bin/bash
# Opens traffic between the downstream and upstream interfaces
# to the specified server and port

# NOTE:  I think we can get this working just specifying the right
# chain, but we *may* need to include the interface names.  TBD.

HOST=""
PORT=""
UPIF=""
DOWNIF=""

while getopts ":u:d:s:p:h?" opt; do
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
    u)
      UPIF=${OPTARG}
      ;;
    d)
      DOWNIF=${OPTARG}
      ;;
  esac
done

if [[ -z "${HOST}" ]] || [[ -z "${PORT} ]]; then
  echo "Usage: ${0} -s SERVER -p PORT"
  exit 1
fi

# Get address
IP=$(host ${HOST} | awk '/has address/ { print $4 ; exit }')
#TODO: Don't assume happy path

# Open it up
iptables -A FORWARD -i ${DOWNIF} -o ${UPIF} -d ${IP} --dport ${PORT} -j ACCEPT

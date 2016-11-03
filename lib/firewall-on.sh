#!/bin/bash
# Starts the basic locked down no-traffic forwarding firewall

UPIF=""
DOWNIF=""

while getopts ":u:d:h?" opt; do
  case $opt in
    :|\?|h)
      echo "Usage: ${0} -u UPSTREAM_IF -d DOWNSTREAM_IF"
      ;;
    u)
      UPIF=${OPTARG}
      ;;
    d)
      DOWNIF=${OPTARG}
      ;;
  esac
done

if [[ -z "${UPIF}" ]] || [[ -z "${DOWNIF} ]]; then
  echo "Usage: ${0} -u UPSTREAM_IF -d DOWNSTREAM_IF"
  exit 1
fi

# Start with basic iptables rules

# Transparent DNS proxy

# Enable forwarding

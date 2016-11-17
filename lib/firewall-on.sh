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
iptables -F
iptables -t nat -A POSTROUTING -o ${UPIF} -j MASQUERADE
iptables -P FORWARD DROP
iptables -A FORWARD -i ${UPIF} -o ${DOWNIF} -m state --state RELATED,ESTABLISHED -j ACCEPT

# Transparent DNS proxy
iptables -t nat -A PREROUTING -i ${DOWNIF} -p tcp,udp -j REDIRECT --to-port 53

# Enable forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward

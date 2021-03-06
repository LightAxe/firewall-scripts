#!/bin/bash
# This script will route traffic from the downstream interface to the upstream interface, 
# as specified on the command line.
# 
# It will only allow upstream traffic to the specified hostnames contained in the plain 
# text file to the specified ports contained in the specified file.
# 
# Usage:  ${0} -d upstream-eth -u upstream-eth -p ports_file -s servers_file
#
# Please note this will cause this system to act as an authoritative DNS server for the
# specified domains, resolving to only a single looked-up address.  This is not meant
# to be in use in any permanent situation.

UPIF=""
DOWNIF=""
SERVERSFILE=""
PORTSFILE=""

while getopts ":d:u:p:s:" opt; do
  case $opt in
    :|\?|h)
      echo "Usage:  ${0} -d upstream-eth -u upstream-eth -p ports_file -s servers_file"
      exit 0
      ;;
    d)
      DOWNIF=${OPTARG}
      ;;
    u)
      UPIF=${OPTARG}
      ;;
    p)
      PORTSFILE=${OPTARG}
      ;;
    s)
      SERVERSFILE=${OPTARG}
      ;;
  esac
done

if [[ -z "${UPIF}" ]] || [[ -z "${DOWNIF}" ]] || [[ -z "${SERVERSFILE}" ]] || [[ -z "${PORTSFILE}" ]]; then
  echo "Usage:  ${0} -d upstream-eth -u upstream-eth -p ports_file -s servers_file"
  exit 1
fi

echo ${UPIF}
echo ${DOWNIF}
echo ${SERVERSFILE}
echo ${PORTSFILE}

# Set up the authoritative domains
for i in $((cat ${SERVERSFILE})); do
  lib/dnsspoof.sh -s ${i}
done

# Switch local resolution to our local DNS server
lib/localdns.sh

# Start the firewall
lib/firewall-on.sh -u ${UPIF} -d ${DOWNIF} 

# Open forwarding ports/hosts
for HOST in $((cat ${SERVERSFILE})); do
  for PORT in $((cat ${PORTSFILE})); do
    lib/allow-destination -s ${HOST} -p ${PORT}
  done
done

# Start dhcp services
lib/start-dhcp.sh -i ${DOWNIF}

# And we're done!

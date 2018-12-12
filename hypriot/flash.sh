#!/bin/bash

printf "Router IP: "

read ROUTER_IP

printf "Device Number: "

read DEVICE_NUMBER

if [[ $DEVICE_NUMBER == 0 ]]; then
  HOSTNAME="K8-MASTER"
else
  HOSTNAME="K8-WORKER-$DEVICE_NUMBER"
fi

HOST_PART=$(expr $DEVICE_NUMBER + 100)
STATIC_IP="${ROUTER_IP%.*}.$HOST_PART"

printf "\n\nFlash Configuration:\n"
printf "$ROUTER_IP\n"
printf "$HOSTNAME\n"
printf "$STATIC_IP\n"
printf "\n\n"

export ROUTER_IP HOSTNAME STATIC_IP

envsubst < cloud-init.yml > /tmp/cloud-init.yml

flash -u /tmp/cloud-init.yml https://github.com/hypriot/image-builder-rpi/releases/download/v1.9.0/hypriotos-rpi-v1.9.0.img.zip

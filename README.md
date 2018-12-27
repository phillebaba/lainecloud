# Laine Cloud
This project contains automation scripts to setup Kubernetes on a 
Raspberry Pi cluster. It includes a base setup allowing persistant 
storage, ingress routing, monitoring, and authentication.

A lot of the setup is based on [carlosedp's work](https://github.com/carlosedp/kubernetes-arm).

## Hardware Setup
This setup is built to run on raspberry pis, tested on 3b and 3b+, but should
work on many other models. For the time being the design does not require any
special router configuration to allow for portability. At minimum this setup
requires 2 Raspberry Pis and a storage device connected to a worker.

## Installation
Use the ´hypriot/flash.sh´ file to flash the OS ROM to the desired SD Card.
This script both installs HypriotOS and sets up some default configurations
that are needed. These include but are not limited to allowing ssh access
by default and setting a static ip number.

## Resources
Bellow are some useful resources for setting up different components needed
for the full setup. The links are oredered from most to least important. 

### Kubeadm
* https://blog.hypriot.com/post/setup-kubernetes-raspberry-pi-cluster/
* https://gist.github.com/elafargue/a822458ab1fe7849eff0a47bb512546f

### External Disk
* https://www.digitalocean.com/community/tutorials/how-to-partition-and-format-storage-devices-in-linux

### NFS
* https://github.com/kubernetes-incubator/external-storage/tree/master/nfs-client
* https://bencane.com/2012/11/23/nfs-setting-up-a-basic-nfs-file-system-share/

### Monitoring
* https://github.com/carlosedp/prometheus-operator-ARM
* https://itnext.io/creating-a-full-monitoring-solution-for-arm-kubernetes-cluster-53b3671186cb
* https://github.com/coreos/prometheus-operator/blob/master/contrib/kube-prometheus/docs/kube-prometheus-on-kubeadm.md

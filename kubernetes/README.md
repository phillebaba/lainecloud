## Resources
Bellow are some useful resources for setting up different components needed
for the full setup.

### Kubeadm
* https://blog.hypriot.com/post/setup-kubernetes-raspberry-pi-cluster/
* https://gist.github.com/elafargue/a822458ab1fe7849eff0a47bb512546f

### NFS
* https://www.digitalocean.com/community/tutorials/how-to-partition-and-format-storage-devices-in-linux
* https://github.com/kubernetes-incubator/external-storage/tree/master/nfs-client
* https://bencane.com/2012/11/23/nfs-setting-up-a-basic-nfs-file-system-share/

### Monitoring
* https://github.com/carlosedp/cluster-monitoring
* https://github.com/carlosedp/prometheus-operator-ARM
* https://itnext.io/creating-a-full-monitoring-solution-for-arm-kubernetes-cluster-53b3671186cb
* https://github.com/coreos/prometheus-operator/blob/master/contrib/kube-prometheus/docs/kube-prometheus-on-kubeadm.md

### OpenBGP
* https://www.danmanners.com/posts/pfsense-bgp-kubernetes/

## Known Issues
There are some known issues currently in the cluster.

### Monitoring
kube-rbac-proxy does not work on k3s due to missing beta api versions

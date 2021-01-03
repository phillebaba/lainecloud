SHELL:=/bin/bash
.ONESHELL:

DEVICE:=/dev/sda
NAME:=master

build:
	export PACKERFILE=./k3s-node.json
	vagrant up

flash:
	export AUTHORIZED_KEY=$$(pass laine-cloud/ssh/nodes | base64 -d | ssh-keygen -y -f /dev/stdin)
	export K3S_TOKEN=$$(pass  laine-cloud/k3s-token)
	USER_DATA="./cloud-init/worker.yaml"
	if [[ $(NAME) == "master" ]]; then
		USER_DATA="./cloud-init/master.yaml"
	fi
	CLOUD_INIT=$$(mktemp)
	cat $${USER_DATA} | envsubst > $${CLOUD_INIT}
	sudo flash --device "$(DEVICE)" --hostname "$(NAME)" --userdata "$${CLOUD_INIT}" ./bin/arm-image.img

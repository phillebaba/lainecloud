SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

KEY_PATH = ~/.ssh/lainecloud-vpn

init:
	DIR=$$(pwd)
	mkdir -p ~/.terraform.d/plugins
	cd ~/.terraform.d/plugins
	[ -f terraform-provider-pass_v1.2.1 ] && exit 0
	wget https://github.com/camptocamp/terraform-provider-pass/releases/download/1.2.1/terraform-provider-pass_1.2.1_linux_amd64.zip
	unzip terraform-provider-pass_1.2.1_linux_amd64.zip
	mv bin/terraform-provider-pass_1.2.1_linux_amd64 terraform-provider-pass_v1.2.1
	rm -rf bin terraform-provider-pass_1.2.1_linux_amd64.zip
	cd $${DIR}/terraform
	terraform init

apply: init
	cd terraform
	terraform apply
	terraform output private_key_pem > $(KEY_PATH)

ansible: apply
	cd terraform
	IP=$$(terraform output vpn_public_ip)
	cd ..
	export ANSIBLE_HOST_KEY_CHECKING=False
	ansible-playbook -u ec2-user -i "$${IP}," -e "ansible_ssh_private_key_file=$(KEY_PATH)" ./ansible/playbook.yml

destroy: init
	cd terraform
	terraform destroy

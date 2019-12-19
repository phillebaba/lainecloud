# https://tech.davis-hansson.com/p/make/
SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

ifeq ($(origin .RECIPEPREFIX), undefined)
  $(error This Make does not support .RECIPEPREFIX. Please use GNU Make 4.0 or later)
endif
.RECIPEPREFIX = >

# Flash SD card with hypriot
hypriot-image:
> ansible-playbook -K hypriot-image/playbook.yml
.PHONY: image

# Install and configure k3s cluster
kubernetes:
> ansible-playbook -i kubernetes/inventory kubernetes/playbook.yml
.PHONY: kubernetes

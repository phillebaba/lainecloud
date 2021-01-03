set -x

sudo apt-get update -qq

sudo DEBIAN_FRONTEND=noninteractive apt-get \
  -y \
  --allow-downgrades \
  --allow-remove-essential \
  --allow-change-held-packages \
 -qq \
 -o Dpkg::Options::="--force-confdef" \
 -o Dpkg::Options::="--force-confold" \
  dist-upgrade

# Provides the add-apt-repository script
sudo apt-get install -y software-properties-common

# Install required packages
sudo apt-get install -y \
    kpartx \
    qemu-user-static \
    git \
    wget \
    curl \
    vim \
    unzip \
    gcc \
    ansible

# Download and install packer
[[ -e /tmp/packer ]] && rm -rf /tmp/packer*
wget https://releases.hashicorp.com/packer/1.5.2/packer_1.5.2_linux_amd64.zip \
    -q -O /tmp/packer_1.5.2_linux_amd64.zip
cd /tmp
unzip -u packer_1.5.2_linux_amd64.zip
sudo cp packer /usr/local/bin
rm -rf /tmp/packer*
cd ..

# Download and install packer plugin
PLUGIN_DIR=${PLUGIN_DIR:-/root/.packer.d/plugins}
sudo mkdir -p $PLUGIN_DIR
URL="https://github.com/solo-io/packer-builder-arm-image/releases/download/v0.1.6/packer-builder-arm-image"
sudo wget -O $PLUGIN_DIR/packer-builder-arm-image $URL
sudo chmod +x $PLUGIN_DIR/packer-builder-arm-image

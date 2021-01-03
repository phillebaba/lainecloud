set -x

PACKER_CACHE_DIR=/root/.packer-cache
PACKER_LOG=$(mktemp)
sudo packer build /vagrant/${PACKERFILE} | tee ${PACKER_LOG}
BUILD_NAME=$(grep -Po "(?<=Build ').*(?=' finished.)" ${PACKER_LOG})
IMAGE_PATH=$(grep -Po "(?<=--> ${BUILD_NAME}: ).*" ${PACKER_LOG})
rm -f ${PACKER_LOG}
if [[ -f ${HOME}/${IMAGE_PATH} ]]; then
  mkdir -p /vagrant/bin
  sudo cp ${HOME}/${IMAGE_PATH} /vagrant/bin/${BUILD_NAME}.img
else
  echo "Error: Unable to find build artifact."
  exit
fi

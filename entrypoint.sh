#!/bin/bash 

set -euo pipefail

if [[ -z "$GITHUB_WORKSPACE" ]]; then
  echo "Set the GITHUB_WORKSPACE env variable."
  exit 1
fi

cd "${GITHUB_WORKSPACE}"
export HOME=$(echo $GITHUB_WORKSPACE)

if [[ "${BUILD_MODE}" == 'hugo' ]]; then
  hugo version
  hugo $1
fi

if [[ "${BUILD_MODE}" == 'doks' ]]; then
  curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -c "apt install -y nodejs"
  sudo apt install -y npm
  npm install
  npm run build
fi

mkdir "${HOME}/.ssh"
echo "${VPS_DEPLOY_KEY}" > "${HOME}/.ssh/id_rsa_deploy"
chmod 600 "${HOME}/.ssh/id_rsa_deploy"

rsync --version
sh -c "
rsync -r "${GITHUB_WORKSPACE}/public/" -e 'ssh -i ${HOME}/.ssh/id_rsa_deploy -o StrictHostKeyChecking=no -p ${VPS_DEPLOY_PORT}' \
  ${VPS_DEPLOY_USER}@${VPS_DEPLOY_HOST}:${VPS_DEPLOY_DEST}
"


exit 0

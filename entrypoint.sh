#!/bin/sh -l

set -euo pipefail

if [[ -z "$GITHUB_WORKSPACE" ]]; then
  echo "Set the GITHUB_WORKSPACE env variable."
  exit 1
fi

cd "${GITHUB_WORKSPACE}"

hugo version
hugo $1

mkdir "${HOME}/.ssh"
echo "${VPS_DEPLOY_KEY}" > "${HOME}/.ssh/id_rsa_deploy"
chmod 600 "${HOME}/.ssh/id_rsa_deploy"

rsync --version
# sh -c "
# rsync -r  \
#   -e 'ssh -p ${VPS_DEPLOY_PORT} -i ${HOME}/.ssh/id_rsa_deploy -o StrictHostKeyChecking=no' \
#   ${GITHUB_WORKSPACE}/public/ \
#   ${VPS_DEPLOY_USER}@${VPS_DEPLOY_HOST}:${VPS_DEPLOY_DEST}
# "

sh -c "
rsync -r "${GITHUB_WORKSPACE}/public/" -e 'ssh -i ${HOME}/.ssh/id_rsa_deploy -o StrictHostKeyChecking=no -p ${VPS_DEPLOY_PORT}' \
  ${VPS_DEPLOY_USER}@${VPS_DEPLOY_HOST}:${VPS_DEPLOY_DEST}
"

exit 0

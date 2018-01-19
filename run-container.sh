#!/bin/bash

# TL; DR:
#
# Generate a cert:
# $ ./run-container.sh certbot53 certonly -d my-domain.com
#
# Renew a cert:
# $ ./run-container.sh certbot53 renew
#
# Upload all the certs in the persistent volume to Hashicorp Vault
# $ ./run-container.sh to-vault


cd $(dirname $0)
IMAGE=$(docker build -q -t certbot53:latest build-context)

# if you haven't set environment variables, tries to pull them straight out of
# the relevant dotfiles.
AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID:-$(aws configure get aws_access_key_id)}
AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY:-$(aws configure get aws_secret_access_key)}
VAULT_TOKEN=${VAULT_TOKEN:-$(cat ${HOME}/.vault-token)}

docker run --rm \
  -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
  -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
  -e VAULT_ADDR=$VAULT_ADDR \
  -e VAULT_TOKEN=$VAULT_TOKEN \
  --mount source=certbot53,target=/certbot53 \
  ${IMAGE} $@

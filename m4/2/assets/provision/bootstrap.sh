#!/bin/bash

set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value

########################
# Provion with ansible
########################

echo " ***************************************************************************** "
echo " *** Starting provision with ansible (will take some time...)"
echo " ***************************************************************************** "

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
export ANSIBLE_CONFIG="${SCRIPT_DIR}/ansible.cfg"

ANSIBLE_EXTRA_VARS=""

# run ansible
ansible-playbook "$SCRIPT_DIR/playbooks/install-docker.yml" --extra-vars="$ANSIBLE_EXTRA_VARS"
ansible-playbook "$SCRIPT_DIR/playbooks/deploy-nginx.yml" --extra-vars="$ANSIBLE_EXTRA_VARS"
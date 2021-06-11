#!/bin/bash

set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value

# validate, that parameter with sources is passed
[ -z $1 ] && echo "pass empty sources folder as parameter - it will be used to store the sources, ansible-dev and ansible-env into it" && exit 1

export DEBIAN_FRONTEND="noninteractive"
export PYTHONUNBUFFERED=1

########################
# Pre provision provisioning
########################

# install ansible if needed
if [ -z "`which ansible-playbook`" ]; then
   echo " ***************************************************************************** "
   echo " *** Starting installation of ansible "
   echo " ***************************************************************************** "
   apt-get update
   apt-get -q -y install software-properties-common sshpass
   add-apt-repository --yes --update ppa:ansible/ansible
   apt-get -q -y update
   apt-get -q -y install ansible
fi

########################
# Prepare ansible env
########################

# configure default ENV dir variable
export ANSIBLE_ENV_DIR=$1/ansible-env/

cp /etc/environment /tmp/env_temp.txt
echo 'ANSIBLE_ENV_DIR="'$1'/ansible-env/"' >> /tmp/env_temp.txt
sudo cp /tmp/env_temp.txt /etc/environment
rm /tmp/env_temp.txt

echo " ***************************************************************************** "
echo " *** Starting configuration of with /etc/ansible/ansible_cfg"
echo " ***************************************************************************** "

# setup configuration
ansible-playbook $1/ansible-dev/playbooks/install_ansible_cfg.yml -i $1/ansible-dev/inventory.ini -e inventory_dir=$1/ansible-dev

########################
# Provion with ansible
########################

echo " ***************************************************************************** "
echo " *** Starting provision with ansible (will take some time...)"
echo " ***************************************************************************** "

ANSIBLE_EXTRA_VARS=""

# run ansible
ansible-playbook "$1/ansible-dev/playbooks/install-docker.yml" --extra-vars="$ANSIBLE_EXTRA_VARS"
# ansible-playbook "$SCRIPT_DIR/ansible/playbooks/install_docker.yml" --extra-vars="$ANSIBLE_EXTRA_VARS"
# ansible-playbook "$SCRIPT_DIR/ansible/playbooks/docker_run_db.yml" --extra-vars="$ANSIBLE_EXTRA_VARS"
# ansible-playbook "$SCRIPT_DIR/ansible/playbooks/docker_run_nginx.yml" --extra-vars="$ANSIBLE_EXTRA_VARS"
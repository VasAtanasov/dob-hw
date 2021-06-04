#!/bin/bash

set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value

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

mkdir -p /etc/ansible
printf "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

cp /etc/hosts /tmp/hosts_temp.txt
echo '127.0.0.1	my.docker.com' >> /tmp/hosts_temp.txt
cp /tmp/hosts_temp.txt /etc/hosts
rm /tmp/hosts_temp.txt

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
ansible-galaxy install geerlingguy.docker
ansible-playbook "$SCRIPT_DIR/playbooks/install-docker.yml" --extra-vars="$ANSIBLE_EXTRA_VARS"
ansible-playbook "$SCRIPT_DIR/playbooks/deploy-nginx.yml" --extra-vars="$ANSIBLE_EXTRA_VARS"


echo " ***************************************************************************** "
echo " *** curl my.docker.come"
echo " ***************************************************************************** "
curl my.docker.com


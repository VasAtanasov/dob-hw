#!/bin/bash

set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value

export DEBIAN_FRONTEND="noninteractive"
export PYTHONUNBUFFERED=1

disable_sudo_password() {
  local username="${1}"
  cp /etc/sudoers /etc/sudoers.bak
  bash -c "echo '${username} ALL=(ALL) NOPASSWD: ALL' | (EDITOR='tee -a' visudo)"
}

disable_sudo_password 'vagrant'

# Enable PasswordAuthentication beacause ubuntu vagrant boxes comes with PasswordAuthentication disabled
sed -i '/.*PasswordAuthentication.*/d' /etc/ssh/sshd_config
echo 'PasswordAuthentication yes' | tee -a /etc/ssh/sshd_config > /dev/null
service sshd restart
service sshd status

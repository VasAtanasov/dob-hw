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

disable_sudo_password("vagrant")
# disable_sudo_password("jenkisn")

sed -i '/.*PasswordAuthentication.*/d' /etc/ssh/sshd_config
echo 'PasswordAuthentication yes' | tee -a /etc/ssh/sshd_config > /dev/null
service sshd restart
service sshd status

sudo apt-get update
sudo apt-get install -y openjdk-11-jdk

wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

sudo apt-get update
sudo apt-get -y install jenkins

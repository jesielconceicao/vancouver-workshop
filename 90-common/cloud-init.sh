#!/bin/bash
set -ex

echo "ubuntu:openstackhelm" | sudo -H chpasswd
sudo -H sed -i 's|PasswordAuthentication no|PasswordAuthentication yes|g' /etc/ssh/sshd_config
sudo -H systemctl restart sshd

sudo -H su -c 'git clone https://github.com/sktelecom-oslab/vancouver-workshop.git /opt/vancouver-workshop' ubuntu
sudo -H su -c 'git clone https://git.openstack.org/openstack/openstack-helm /opt/openstack-helm' ubuntu
sudo -H su -c 'git clone https://git.openstack.org/openstack/openstack-helm-infra /opt/openstack-helm-infra' ubuntu

sudo -H su -c 'cd /opt/openstack-helm; ./tools/deployment/developer/common/000-install-packages.sh; ./tools/deployment/developer/common/000-install-packages.sh; ./tools/deployment/developer/common/010-deploy-k8s.sh; ./tools/deployment/developer/common/020-setup-client.sh' ubuntu
sudo -H su -c '(cd /opt/openstack-helm; make all pull-all-images)' ubuntu
sudo -H su -c '(cd /opt/openstack-helm-infra; make all pull-all-images)' ubuntu
sudo -H su -c '(/opt/vancouver-workshop/90-common/pull-ocata-images.sh)' ubuntu

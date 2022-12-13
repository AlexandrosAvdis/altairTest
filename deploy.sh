# Run this after escalating priviledges with:
# sudo -i

# Install and configure basic dependencies
setenforce permissive
yum install -y zip bzip2 unzip gcc cloud-init
sed -i '/SELINUX=enforcing/c\SELINUX=permissive' /etc/sysconfig/selinux
sed -i '/SELINUX=disabled/c\SELINUX=permissive' /etc/sysconfig/selinux
#yum install -y subscription-manager; subscription-manager repos --enable rhel-7-server-devtools-rpms

# Install and configure tortuga
cd /home/navops-mgmt-id/
tar -xvjf tortuga-7.1.0+revabca874.707564555.tar.bz2
cd tortuga-7.1.0+revabca874.707564555
./install-tortuga.sh
cp ../navops-project-*.json /opt/tortuga/etc/gcloud-key.json
# Command below requires interactive input in licensing agreement.
/opt/tortuga/bin/tortuga-setup --defaults 
exec -l $SHELL

# Install relevant kits
cd /home/navops-mgmt-id/
install-kit kit-uge-8.6.18-3391464397.tar.bz2
install-kit kit-unisight-2.3.2-3391838607.tar.bz2
install-kit kit-launch-2.3.2-3392175276.tar.bz2
install-kit kit-gceadapter-7.1.2-3391471589.tar.bz2
get-kit-list

# Configure GCP component
enable-component -p gceadapter management
puppet agent -t
# Command below has given issue 1.x
setup-gce
systemctl restart tortugawsd celery
adapter-mgmt show -r GCP -p Default
#adapter-mgmt update -r GCP -p Default -s image_url=https://www.googleapis.com/compute/v1/projects/navops-devel/global/images/centos7-20210225
adapter-mgmt show -r GCP -p Default
create-hardware-profile --name GCP
update-hardware-profile --name GCP --resource-adapter GCP --location remote

# NavOps Configuration
enable-component -p proxy
puppet agent -t
enable-component -p dex
puppet agent -t
enable-component -p consul
enable-component -p nats
puppet agent -t
enable-component -p agent
# Command below has given issue 2.x
puppet agent -t
enable-component -p controller
enable-component -p controller_cli
enable-component -p templater
enable-component -p automation_sdk
enable-component -p status_aggregator
enable-component -p image_builder
enable-component -p dns
puppet agent -t
enable-component -p webui
puppet agent -t

# Setup the monitoring server with the Unisight software
setup-unisight
enable-component --software-profile Monitoring-Reporting controller_cli
enable-component --software-profile Monitoring-Reporting automation_sdk
enable-component --software-profile Monitoring-Reporting agent
enable-component --software-profile Monitoring-Reporting puppet
update-software-profile --name Monitoring-Reporting --soft-locked
update-hardware-profile --name Monitoring-Reporting --name-format='*,monitoring'
add-nodes -n1 --software-profile Monitoring-Reporting --hardware-profile Monitoring-Reporting --force --user-data /opt/tortuga/config/base/cloud-config-redhat.yaml
# Wait for node to join the cluster.
# Command below should list the Monitoring-Reporting node but does not (Issue 3.x)
get-node-status --software-profile Monitoring-Reporting
get-node-status

#
export PATH=$PATH:/opt/navops-launch/bin/
navopsctl auth login

sed -i "s/INSTALLER_HOSTNAME/$HOSTNAME/g" cluster-specification.yaml
navopsctl clusterspecifications create cluster-specification.yaml
navopsctl clusterprofilespecifications create -u /opt/tortuga/config/base/cloud-config-redhat.yaml  execd-clusterprofilespecification.yaml
navopsctl clusterprofilespecifications create -u /opt/tortuga/config/base/cloud-config-redhat.yaml qmaster-clusterprofilespecification.yaml

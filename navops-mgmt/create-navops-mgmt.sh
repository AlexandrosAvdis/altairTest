# List project, to make sure we are on the correct GCP project
echo "Your current GCP project is:"
gcloud config get project

navops_mgmt_ip=`gcloud compute instances describe navops-mgmt --format="get(networkInterfaces[0].accessConfigs[0].natIP)" --verbosity=none`
[ ! -z "$navops_mgmt_ip" ] && ssh-keygen -R $navops_mgmt_ip
[ ! -z "$navops_mgmt_ip" ] && export ssh_config_navops_line=`grep -n $navops_mgmt_ip ~/.ssh/config | awk -F: '{print $1}'`
[ ! -z "$navops_mgmt_ip" ] && gcloud compute instances delete navops-mgmt

gcloud compute instances create navops-mgmt \
	--project=navops-project-47315 \
	--zone=us-central1-c --machine-type=e2-standard-4 \
	--network-interface=network-tier=PREMIUM,subnet=default \
	--maintenance-policy=MIGRATE --provisioning-model=STANDARD \
	--service-account=navops-service-account@navops-project-47315.iam.gserviceaccount.com \
	--scopes=https://www.googleapis.com/auth/cloud-platform \
	--tags=http-server,https-server \
	--create-disk=auto-delete=yes,boot=yes,device-name=navops-mgmt,image=projects/centos-cloud/global/images/centos-7-v20221206,mode=rw,size=20,type=projects/navops-project-371121/zones/us-central1-c/diskTypes/pd-balanced \
	--no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any

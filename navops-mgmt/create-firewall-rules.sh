#gcloud config set account navops-service-account@navops-project-<project id>.iam.gserviceaccount.com
#gcloud auth login
#gcloud auth list

gcloud compute --project=navops-project-47315 firewall-rules create ssh         --description="SSH access" \
	--direction=INGRESS --priority=1000 --network=default --action=ALLOW \
	--rules=tcp:22 --source-ranges=0.0.0.0/0
gcloud compute --project=navops-project-47315 firewall-rules create rpcbind     --description="rpcbind (required for NFS)" \
	--direction=INGRESS --priority=1010 --network=default --action=ALLOW \
	--rules=tcp:111,udp:111 --source-ranges=0.0.0.0/0
gcloud compute --project=navops-project-47315 firewall-rules create navops-web  --description="NavOps Web Console" \
	--direction=INGRESS --priority=1020 --network=default --action=ALLOW \
	--rules=tcp:443 --source-ranges=0.0.0.0/0
gcloud compute --project=navops-project-47315 firewall-rules create rsync       --description="rsync" \
	--direction=INGRESS --priority=1030 --network=default --action=ALLOW \
	--rules=tcp:873,udp:873 --source-ranges=0.0.0.0/0
gcloud compute --project=navops-project-47315 firewall-rules create nfs         --description="NFS" \
	--direction=INGRESS --priority=1040 --network=default --action=ALLOW \
	--rules=tcp:2049,udp:2049 --source-ranges=0.0.0.0/0
gcloud compute --project=navops-project-47315 firewall-rules create graphql-api --description="Internal GraphQL API" \
	--direction=INGRESS --priority=1050 --network=default --action=ALLOW \
	--rules=tcp:3001 --source-ranges=0.0.0.0/0
gcloud compute --project=navops-project-47315 firewall-rules create nats        --description="NATS message bus" \
	--direction=INGRESS --priority=1060 --network=default --action=ALLOW \
	--rules=tcp:4222 --source-ranges=0.0.0.0/0
gcloud compute --project=navops-project-47315 firewall-rules create uge-gmaster --description="Univa Grid Engine qmaster default port" \
	--direction=INGRESS --priority=1070 --network=default --action=ALLOW \
	--rules=tcp:6444 --source-ranges=0.0.0.0/0
gcloud compute --project=navops-project-47315 firewall-rules create uge-execd   --description="Univa Grid Engine execd default port" \
	--direction=INGRESS --priority=1080 --network=default --action=ALLOW \
	--rules=tcp:6445 --source-ranges=0.0.0.0/0
gcloud compute --project=navops-project-47315 firewall-rules create http-fds    --description="Interal HTTP File Distribution Server" \
	--direction=INGRESS --priority=1090 --network=default --action=ALLOW \
	--rules=tcp:8008 --source-ranges=0.0.0.0/0
gcloud compute --project=navops-project-47315 firewall-rules create pupet       --description="Puppet server" \
	--direction=INGRESS --priority=1100 --network=default --action=ALLOW \
	--rules=tcp:8140 --source-ranges=0.0.0.0/0
gcloud compute --project=navops-project-47315 firewall-rules create monitoring-api --description="Internal Monitoring API" \
	--direction=INGRESS --priority=1110 --network=default --action=ALLOW \
	--rules=tcp:8421 --source-ranges=0.0.0.0/0
gcloud compute --project=navops-project-47315 firewall-rules create data-api       --description="Internal Data API" \
	--direction=INGRESS --priority=1120 --network=default --action=ALLOW \
	--rules=tcp:8423 --source-ranges=0.0.0.0/0
gcloud compute --project=navops-project-47315 firewall-rules create tortuga        --description="Tortuga web service" \
	--direction=INGRESS --priority=1130 --network=default --action=ALLOW \
	--rules=tcp:8443 --source-ranges=0.0.0.0/0
gcloud compute --project=navops-project-47315 firewall-rules create uge-rest-api   --description="Interal Univa Grid Engine REST API" \
	--direction=INGRESS --priority=1140 --network=default --action=ALLOW \
	--rules=tcp:9000 --source-ranges=0.0.0.0/0

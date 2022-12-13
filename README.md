# altairTest
Code for investigating NavOps deployment on GCP

Steps for deployment:

1. Create a new project in the Google Cloud Platform, named ```navops-project```
2. Create a new service account in the ```navops-project```.
   1. Assign roles ```Compute Image User``` and ```Compute Admin```. See NavOps documentation for more details.
   2. Create and download a json key for the service account.
3. Follow the comments at the top of ```navops-mgmt/create-firewall-rules.sh``` to log into the service account created above, using the downloaded json key.
4. Enable Compute Engine API in the Google Cloud Platform for ```navops-project```.
5. Create the necessary firewall rules.
   1. Run script ```navops-mgmt/create-firewall-rules.sh```.
6. Create the NavOps managemnt instance on GCP.
   1. Run script ```navops-mgmt/create-navops-mgmt.sh```.
   2. Edit ```~/.ssh/config``` to facilitate remote SSH access into the instance. The following template is recommended:
   ```
   
7. Copy NavOps deployment files onto management instance
   1. Run script ```copy.sh```

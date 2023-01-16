# Altair Test
Investigating NavOps deployment on Google Cloud Platform (GCP).

Steps for deployment:

1. Create a public-private key pair to facilitate SSH access to the management instance.
   1. Issue  ```ssh-keygen -t rsa -b 4096 -C "navops-mgmt-id" -f $HOME/.ssh/navops-mgmt-id-rsa ``` at a command line. Use a strong passphrase for the key and store it securely.
2. Create a new project in the Google Cloud Platform, named ```navops-project```.
   1. Add the public key from step 1 to the Project Metadata. 
3. Create a new service account in the ```navops-project```.
   1. Assign roles ```Compute Image User``` and ```Compute Admin```. See NavOps documentation for more details.
   2. Create a JSON key for the service account.
   3. Download the JSON key into the folder containing the present scripts. 
   4. On Google Cloud Console inspect the Dashboard of the ```navops-project``` and make a note of the ID.
   5. Use the gcloud CLI to log into the service account created above, using the downloaded JSON key: Run ```gcloud config set account navops-service-account@navops-project-<project id>.iam.gserviceaccount.com``` in a terminal, where ```<project id>``` was noted in step 3.iv above.
   6. Run ```gcloud auth login``` in a terminal, and complete the authentication in the browser window when prompted.
   7. Run ```gcloud auth list``` in a terminal to list the authetication details and verify you are logged into the project.
4. Enable Compute Engine API in the Google Cloud Platform for ```navops-project```.
5. Create the necessary firewall rules.
   1. Run script ```navops-mgmt/create-firewall-rules.sh```.
6. Create the NavOps management instance on GCP.
   1. Run script ```navops-mgmt/create-navops-mgmt.sh```. Make a note of the management instance IP, it will be used in the next step.
   2. Edit ```~/.ssh/config``` to facilitate remote SSH access into the instance. The following template is recommended:
   ```
   Host altairTest
     ServerAliveInterval 20
     UseKeychain yes
     AddKeysToAgent yes
     HostName <management instance IP>
     User navops-mgmt-id
     IdentityFile ~/.ssh/navops-mgmt-id-rsa
   ```
   The ```<management instance IP>``` must be changed to the IP returned in step 8.i
7. Copy NavOps deployment files onto management instance
   1. Run script ```copy.sh```. Note the script uses the ssh configuration from step 8.ii.
8. Log on the management instance.
9. Run the commands given in script ```deploy.sh``` on the management instance, while crosss checking with NavOps installation documentation.

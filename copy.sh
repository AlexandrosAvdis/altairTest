scp nl232rc3.tar altairTest:
ssh altairTest tar -xvf nl232rc3.tar
scp *.json altairTest:
scp *.yaml altairTest:
ssh altairTest sudo yum install -y tmux

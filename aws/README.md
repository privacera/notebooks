# Prerequisites

You need IAM roles to access AWS services. Also, EC2 instance with Amazon Linux 2 AMI generally has an older
version of Python which is not supported by LangChain. The recommendation is to use Docker to run the quick 
start applications or use SageMaker. This quick start guide uses Docker to run the applications.

## EC2 Instance
Create an EC2 instance with Amazon Linux 2 AMI. Make sure to have the necessary IAM roles to access AWS services.
This quick start uses Bedrock, OpenSearch and AWS S3 services. OpenSearch is included in the Docker Compose, so you
will IAM roles to access AWS S3 and Bedrock.

### IAM Roles
1. Access to Bedrock
2. Read/Write access to S3 bucket where the data for the VectorDB will be stored

### Security Group
Make sure to have the necessary ports open for the services. The following ports are required:
1. 22 (SSH)
2. 8888 (JupyterHub)
3. 3535 (Privacera Secure Chat)

Create ec2 instance with amazon linux and ssh to the instance

## Setup the EC2 instance
### Install Docker
```buildoutcfg
sudo yum install -y docker
sudo sed -i 's/32768:65536/1024000:1024000/g' /etc/sysconfig/docker
sudo cat /etc/sysconfig/docker
sudo service docker start
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user
exit
```

### Install docker-compose
```buildoutcfg
DOCKER_COMPOSE_VERSION="1.23.2"
sudo curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### Increase the number of memory maps available to OpenSearch.
Edit the sysctl config file
```buildoutcfg
sudo vi /etc/sysctl.conf
```
Add a line to define the desired value or change the value if the key exists, and then save your changes.
```buildoutcfg
vm.max_map_count=262144
```
Reload the kernel parameters using sysctl
```buildoutcfg
sudo sysctl -p
```

Verify that the change was applied by checking the value
```buildoutcfg
cat /proc/sys/vm/max_map_count
```

### Install git
```buildoutcfg
sudo yum install -y git
```

### Download the repo
```buildoutcfg
git clone https://gitlab.com/privacera/paig/paig-opensearch-governance-demo.git
```

### Start the services
This will start docker containers for JupyterHub and OpenSearch. It will also mount the required volumes for the 
services.
```buildoutcfg
./paig-aws-quickstart start
```

### Stop the services
```buildoutcfg
./paig-aws-quickstart stop
```


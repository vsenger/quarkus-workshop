#!/bin/bash
# Grow C9 FS
INSTANCE_ID=$(curl -s http://instance-data/latest/meta-data/instance-id)
echo "$INSTANCE_ID"

VOLUME_ID=$(aws ec2 describe-instances --instance-ids=$INSTANCE_ID --query "Reservations[0].Instances[0].BlockDeviceMappings[0].Ebs.VolumeId" --output text)
aws ec2 modify-volume --volume-id $VOLUME_ID --size 128

sudo growpart /dev/xvda 1
sudo xfs_growfs -d /

# Install SDKMan, JDK, Maven, Quarkus
curl -s "https://get.sdkman.io" | bash
source "/home/ec2-user/.sdkman/bin/sdkman-init.sh"

JAVA_VERSION=11.0.16-amzn
sdk install java ${JAVA_VERSION}
sdk default java ${JAVA_VERSION}
sdk install maven
sdk install quarkus

# TODO: Install proper aws-cli with dependencies
sudo -s
yum install -y amazon-linux-extras
amazon-linux-extras enable python3.8
yum clean metadata
yum -y remove python3.7
yum -y install python3.8
alternatives --install /usr/bin/python python /usr/bin/python3.8 1

yum remove awscli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
/usr/local/bin/aws --version

rm $(which sam)
brew tap aws/tap
brew install aws-sam-cli

# END TODO

# Clone repo
git clone https://github.com/CaravanaCloud/modern-java-workshop

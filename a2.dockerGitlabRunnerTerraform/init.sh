#!/bin/bash
# yum update -y
# yum install git -y
sudo apt update
sudo apt install unzip
# sudo apt-get install python3-pip -y
# pip3 install boto3

ansible_install_ubuntu () {
    # Create ansadmin user on all slave nodes
    # edit sshd_config file for password authentication yes, restart service
    # ssh-copy-id username@ip to copy the keys
    
    update-alternatives --set editor /usr/bin/vim.basic
    apt install ansible tree -y
    # useradd -m -p $(openssl passwd -1 tdc) -s /bin/bash ansadmin
}

install_aws_cli () {
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install

}

install_gitlab_runner () { 
 sudo curl -L --output /usr/local/bin/gitlab-runner "https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64"
 sudo chmod +x /usr/local/bin/gitlab-runner
 sudo useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash
 sudo gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner
 sudo gitlab-runner start
 sudo apt-get -y install docker docker.io
 sudo usermod -a -G docker,sudo gitlab-runner # ALL=(ALL) NOPASSWD:ALL
 echo "gitlab-runner ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
 mv /home/gitlab-runner/.bash_logout .bash_logout.bkp
 
 # check for the registration token
 sudo gitlab-runner register \
  --non-interactive \
  --url "https://gitlab.com/" \
  --registration-token "Your_Gitlab_Token" \
  --executor "shell" \
  --tag-list "runner1" \
  --description "shell runner"
}
setup_credential_storage_docker () { 
# https://brain2life.hashnode.dev/how-to-set-up-secure-local-credential-storage-for-docker-on-ubuntu-2004
sudo apt-get install rng-tools pass -y
sudo rngd -r /dev/urandom
# https://shawngrover.medium.com/generate-gpg-key-without-passphrase-6dec71caecf8
gpg --batch --passphrase '' --quick-gen-key kumartim46@gmail.com default default

mkdir ~/bin
cd ~/bin
echo 'export PATH=$PATH:~/bin' >> ~/.bashrc
wget https://github.com/docker/docker-credential-helpers/releases/download/v0.6.3/docker-credential-pass-v0.6.3-amd64.tar.gz
tar xvzf docker-credential-pass-v0.6.3-amd64.tar.gz
chmod a+x docker-credential-pass
sudo cp docker-credential-pass /usr/local/bin

gpg_id=`gpg --list-secret-keys | awk 'NR==4 {print $1}'`
pass init $gpg_id
echo $gpg_id | pass insert docker-credential-helpers/docker-pass-initialized-check
# var=/home/gitlab-runner/.docker/config.json
sudo touch /home/gitlab-runner/.docker/config.json
sudo chown -R gitlab-runner:gitlab-runner /home/gitlab-runner/.docker
sudo echo -e "{\n \t\"credsStore\": \"pass\"\n}" > /home/gitlab-runner/.docker/config.json

## docker login, docker_pass is base64 encoded
docker_pass=`openssl enc -base64 -d <<< 'Your_Pass'`

# sudo docker_pass=`base64 --decode /path/to/file`
echo "$docker_pass" | docker login registry.gitlab.com -u kumartim46 --password-stdin
echo `whoami`
}
# install_aws_cli
install_gitlab_runner
export -f setup_credential_storage_docker
su gitlab-runner -c "bash -c setup_credential_storage_docker"

#  su -c './test.sh' gitlab-runner setup_credential_storage_docker
# ansible_install_ubuntu



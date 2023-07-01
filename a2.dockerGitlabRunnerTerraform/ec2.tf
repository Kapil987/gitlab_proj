# Create EC2 
resource "aws_instance" "web" {
  # 0 - amazon linux, 1 - ubuntu
  # 0 - General Use case (t2.micro), 1 - minikube (t2.medium)
  ami           = var.ami_id_amazon[1]
  instance_type = var.type_instance[0]
  # availability_zone           = element(var.avaialability_zones, count.index)
  key_name                    = "tim-virginia"
  vpc_security_group_ids      = [aws_security_group.allow_web.id]
  associate_public_ip_address = true
  count                       = 1
  user_data_replace_on_change = false
  root_block_device {
    delete_on_termination = true
    # iops = 100
    volume_size = 15
    volume_type = "gp2"
  }

  tags = {
    # buildSeverName = ["jenkins-","minikube-","dockerBuildServer-","ansibleMaster-"]
    Name        = "${var.buildSeverName[3]}${count.index}"
    Environment = "dev"
    Type        = "singlebox"
  }

  user_data = file("init.sh")
}
/*
  # Key and local file will not get deleted, when EC2 is destroyed
  provisioner "file" {
    source      = "C:\\Learnings\\terraform_prac\\j9.dockerBuildServer\\transferFiles"
    destination = "/tmp"

  }
  connection {
    type        = "ssh"
    # user        = "ec2-user"
    user        = "ubuntu"
    private_key = file("C:\\Users\\Kapil\\Downloads\\aws\\vinod-eks.pem")
    # host        = "${self.private_ip}"
    host = self.public_ip

  }
}
*/

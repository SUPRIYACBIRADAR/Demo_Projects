provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "HelloWorld_EC2" {
  ami             = "ami-04b4f1a9cf54c11d0"
  instance_type   = "t2.micro"
  key_name        = "HelloKey"
  security_groups = ["aws_security_group.Hello_sg.name"]


tags = {
  Name = "Terraform-EC2"
}

user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y apache2 ansible docker.io curl
              systemctl start apache2
              systemctl enable apache2
              systemctl start docker
              systemctl enable docker
              curl -fsSL https://get.docker.com | sh
              curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
              echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
              apt update -y
              apt install -y kubelet kubeadm kubectl
              systemctl start kubelet
              systemctl enable kubelet
              curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | tee /usr/share/keyrings/jenkins-keyring.asc
              echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | tee /etc/apt/sources.list.d/jenkins.list
              apt update -y
              apt install -y openjdk-11-jdk jenkins
              systemctl start jenkins
              systemctl enable jenkins
              EOF
}

resource "aws_security_group" "Hello_sg" {
  name        = "Terraform_sg"
  description = "Allow ssh and http inbound traffic"
    
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "public_ip" {
  value = "aws_instance.HelloWorld_EC2.public_ip"
}
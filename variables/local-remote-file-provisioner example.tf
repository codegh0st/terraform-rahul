


# LOCAL FILE PROVISIONER,
# This provisoner block will be under aws_instance block, using self.public_ip we are refering its public ip
provisioner "file" {
  connection {
     type     = "ssh"
     user = "ec2-user"
     private_key = "${file("~/DevOps.pem")}"
     host = self.public_ip # on this ip tf will try to connect using ssh with user ec2-users
  }
  source = "index.html"
  description = "/var/www/html/index.html"

}

/* In  above file provisoner is copying index.thml to var/www/html folder of that newly
created server, there httpd web server is already installed using remote exec proviser,
and httpd server default path is var/ww/html. 
hence we will able to acces index.thm if access <public-ip>:80
*/




#############################

# REMOTE EXEC PROVISONER
# Create ec2 instance, connect and install apache web server (httpd) using remote exec on this 
# newly created instance, create security group which allow inbound traffic on ssh 22 http 80
# attach this security group to this newly created ec2 instance
# How to acces this web server ? give public ip of server:80 redhat enterprise linux test page should open

resource "aws_instance" "demo" {
  ami = "ami-0e07dcaca348a0e68"
  instance_type = "t2.micro"
  key_name = "DevOps" # this is name of pem file, already created on aws currently stored in local machine DevOps.pem
  tags = {
    "Name" = "WebServer"
  }

  vpc_security_group_ids = [aws_security_group.allow-http-ssh-sg]

 # Remote Provisioner Declared & connecing with remote 
  provisioner "remote-exec" { 
   connection {
    type     = "ssh"
    user     = "ec2-user" # red-hat defualt username is ec2-user, we are using redhat ami to create instance
    private_key = "${file("/Users/frutos/DevOps.pem")}" # location of the pem file provided to 'file' function, resouce must be created using this pem in order to connect
    host     = self.public_ip # fetching public ip of newly ccreated ec2, givin to 'host' argmnt, self is used if have to fetch the resouces attribute from inside of that resource. 
  }

    inline = [
      "sudo yum install httpd -y",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      "sudo chmod 777 -R /var/www" # giving rwx permision on /var/www/ folder to everyone, bcoz ec2-user will copy index.html in this folder. 
    ]
  } # remote provisioner block ends

  provisioner "local-exec" { # this prov will run while cration of the resource, 'when' is not provided. 
    command = "sh test. sh" # this script will run on local machine,  
    on_failure = continue # on failure still configuration will continue to run
  }

  provisioner "local-exec" { # this prov will run while creation because when is not given, and by default it runs while creation of the resource
    command = "echo Second loca-exec provsioner"
    on_failure = continue 

  }

  provisioner "local-exec" { # this prov will when destroying the resouce
    command = "echo destory time loca-exec provsioner"
    when = destroy
  }

resource "aws_s3_bucket" "demos3" {
bucket = "foxninous-s3-unique-bucket-name"
tags = {
  "Name" = "Demo 53"
}
}

  provisioner "local-exec" {
    command = "echo destory time loca-exec provsioner in s3 demos3 resource"
    when = destroy
  }
} //aws_instance ends here


# creating security group
resource "aws_security_group" "allow-http-ssh-sg" {
  name        = "allow-http-ssh-sg"
  description = "Allow ssh http"


  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "http-ssh"
  }
}

############################################


# LOCAL EXEC PROVISIONER
resource "aws_instance" "demo" {
  ami = "ami-0e07dcaca348a0e68"
  instance_type = "t2.micro"
  key_name = "DevOps" # this is name of pem file, already created on aws currently stored in local machine DevOps.pem
  tags = {
    "Name" = "WebServer"
  }


  provisioner "local-exec" { # this prov will run while cration of the resource, 'when' is not provided. 
    command = "sh test. sh" # this script will run on local machine,  
    on_failure = continue # on failure still configuration will continue to run
  }

  provisioner "local-exec" { # this prov will run while creation because when is not given, and by default it runs while creation of the resource
    command = "echo Second loca-exec provsioner"
    on_failure = continue 

  }

  provisioner "local-exec" { # this prov will when destroying the resouce
    command = "echo destory time loca-exec provsioner"
    when = destroy
  }

resource "aws_s3_bucket" "demos3" {
bucket = "foxninous-s3-unique-bucket-name"
tags = {
  "Name" = "Demo 53"
}
}

  provisioner "local-exec" {
    command = "echo destory time loca-exec provsioner in s3 demos3 resource"
   when = destroy
  }
}

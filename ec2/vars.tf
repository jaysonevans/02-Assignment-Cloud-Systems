# Create a variable for the chassis
variable "chassis" {
    type = string
    default = "t2.micro"
}

variable "counter" {
    type = number
}

variable "vpc-id" {
    type = string
}

variable "subnet-ids" {
    type = list
}

# Bootstrap information
variable "apache-bootstrap" {
    type = string
    default = <<-EOF
        #!/bin/bash
        yum update -y
        yum install httpd -y
        cd /var/www/html
        echo "<html><body><h1> Jayson Evans $(hostname -f) </h1></body></html>" > index.html
        systemctl restart httpd
        systemctl enable httpd
        EOF
}

# Create a placeholder variable for the security group ID
variable "secgrp-id" {}
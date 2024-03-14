# Get the most recent AMI
data "aws_ami" "most-recent-amazon-linux" {
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["amzn2-ami-*-x86_64-gp2"]
    }
}

# Create EC2
resource "aws_instance" "ec2-1" {
    ami = data.aws_ami.most-recent-amazon-linux.id
    instance_type = var.chassis
    key_name = "syst35144-key1"
    security_groups = [ var.secgrp-name ]
    count = var.counter
    subnet_id = var.subnets.*.id[count.index]
    user_data = var.apache-bootstrap
    tags = { Name = "VM-0${count.index + 1}"}
}
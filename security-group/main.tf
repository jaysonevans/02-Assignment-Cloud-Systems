# Create the security group
resource "aws_security_group" "secgrp-mark-i" {
    name = "secgrp-mark-i"
    description = "Security group created for the Cloud Systems assignment 02."
    vpc_id = var.vpc_id
    tags = { Name = "secgrp-mark-i"}
    
    # Allow SSH
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "142.55.0.0/16" ]
    }

    # Allow HTTP
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [ "142.55.0.0/16" ]
    }
    
    # Allow 8080 (Docker container I)
    ingress {
        from_port = 8080
        to_port = 8081
        protocol = "tcp"
        cidr_blocks = ["142.55.0.0/16"]
    }

    # Allow all outbound
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
}

output "secgrp-mark-i" {
    value = aws_security_group.secgrp-mark-i
}
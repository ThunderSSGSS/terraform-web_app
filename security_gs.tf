#___________LOAD_BALANCER_SECURITY_GROUP____________#

resource "aws_security_group" "lb_security_group" {
    name        = "${var.app_name}-lb-security-group"
    description = "allow http trafic to ${var.app_name}-lb"
    vpc_id      = var.vpc_id

    ingress {
        description = "Allow http"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Environment = var.environment
        Managed_by  = var.managed_by
    }
}


#________________INSTANCES_SECURITY_GROUP_______________#

resource "aws_security_group" "instances_security_group" {
    depends_on = [aws_security_group.lb_security_group]

    name        = "${var.app_name}-instances-security-group"
    description = "allow http trafic from ${var.app_name}-lb to ${var.app_name}-instances"
    vpc_id      = var.vpc_id

    ingress {
        description     = "Allow http from ${var.app_name}-lb"
        from_port       = var.instance_port
        to_port         = var.instance_port
        protocol        = "tcp"
        security_groups = [aws_security_group.lb_security_group.id]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Environment = var.environment
        Managed_by  = var.managed_by
    }
}
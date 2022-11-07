
#________________________TARGET_GROUP________________________#

resource "aws_lb_target_group" "web_app" {
    name        = "${var.app_name}-tg"
    port        = var.instance_port
    protocol    = "HTTP"
    vpc_id      = var.vpc_id

    health_check {
        healthy_threshold   = 2
        unhealthy_threshold = 5
        timeout             = 3
        #protocol = "HTTP"
        port                = var.instance_port
        path                = "/"
        interval            = 300
        #response
        matcher             = "200"
    }

    tags = {
        Environment = var.environment
        Managed_by  = var.managed_by
    }
}


#____________________LOAD_BALANCER____________________#

resource "aws_lb" "web_app" {
    name                = "${var.app_name}-lb"
    internal            = false
    load_balancer_type  = "application"
    security_groups     = [aws_security_group.lb_security_group.id]
    subnets             = [for subnet_id in var.lb_subnet_ids: subnet_id]

    enable_deletion_protection = false

    tags = {
        Environment = var.environment
        Managed_by  = var.managed_by
    }
}


#______LISTERNER______#

resource "aws_lb_listener" "web_app" {
    load_balancer_arn   = aws_lb.web_app.arn
    port                = "80"
    protocol            = "HTTP"

    default_action {
        type = "forward"
        forward {
            target_group { arn = aws_lb_target_group.web_app.arn }
            #target_group {arn = aws_lb_target_group.edge.arn}
        }
    }
}

#___________LAUNCH_TEMPLATE_________________#

resource "aws_launch_template" "web_app" {
    name                    = "${var.app_name}-launch-template"
    image_id                = var.image_id
    instance_type           = var.instance_type
    key_name                = var.key_name
    vpc_security_group_ids  = [aws_security_group.instances_security_group.id]

    tags = {
        Environment = var.environment
        Managed_by  = var.managed_by
    }
    user_data = filebase64("${var.user_data_file}")
}


#_____________AUTO_SCALING_GROUP____________________#

resource "aws_autoscaling_group" "web_app" {
    name                = "${var.app_name}-autoscaling-group"
    max_size            = var.max_instances_size
    min_size            = var.min_instances_size
    desired_capacity    = var.min_instances_size

    health_check_grace_period   = 300
    health_check_type           = "EC2"
    
    vpc_zone_identifier = [for subnet_id in var.instance_subnet_ids: subnet_id]
    target_group_arns   = [aws_lb_target_group.web_app.arn]

    launch_template {
        id      = aws_launch_template.web_app.id
        version = aws_launch_template.web_app.latest_version
    }

    instance_refresh {
        strategy = "Rolling"
        preferences { min_healthy_percentage = 50 }
        triggers = ["tag"]
    }

    lifecycle {
        ignore_changes = [desired_capacity]
    }
 
    tag {
        key                 = "Name"
        value               = "${var.app_name}-instance"
        propagate_at_launch = true
    }

    tag {
        key                 = "Environment"
        value               = var.environment
        propagate_at_launch = true
    }

    tag {
        key                 = "Managed_by"
        value               = var.managed_by
        propagate_at_launch = true
    }
}
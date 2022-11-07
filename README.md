# AWS WEB APP Terraform module

Terraform module which creates a web app with load balancer and autoscaling group.
**Important**: This module is not finished, but you can use for simple tests.

This modules will:
* Create security groups;
* Create a target group;
* Create a load balancer;
* Create a launch template;
* Create a autoscaling group.


## Requirements
The module was tested using:
| Name | Versions |
|------|----------|
| terraform | >= 1.0 |
| aws provider | >= 3.0 |

## Usage

### Creating a Webb app with nginx
1 - Create a file start_nginx.sh, contain the script which install nginx and start on port 80.
```hcl
#!/bin/bash
sudo apt update -y && sudo apt install nginx -y && sudo systemctl start nginx
```

2 - Use the module. <br>
**NB**: The instances needs internet access to download the nginx, so that the subnets with contain the instances must have internet access<br>You can use NAT (for private subnets) or internet gateways.
```hcl
# Imagine that you have same resources: 
# "aws_vpc.example", "aws_subnet.public", "aws_subnet.private" and "aws_key_pair.key"

module "nginx_example" {
    source              = "github.com/ThunderSSGSS/terraform-web_app"
    app_name            = "nginx"
    key_name            = aws_key_pair.key.key_name
    instance_port       = 80
    user_data_file      = "${path.module}/start_nginx.sh"
    vpc_id              = aws_vpc.example.id
    min_instances_size  = 2
    instance_subnet_ids = [aws_subnet.private]
    lb_subnet_ids       = [aws_key_pair.public]
}
```


## Resources

| Name | Type |
|------|------|
| [aws_security_group.lb_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.instances_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_lb_target_group.web_app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb.web_app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.web_app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_launch_template.web_app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_autoscaling_group.web_app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| app_name | Prefix of all resources name | string | null | yes |
| environment | Tag 'Environment' of all resources | string | " " | no |
| managed_by | Tag 'Managed_by' of all resources | string | " " | no |
| image_id | The image id. Default is ubuntu 22 | string | ami-08c40ec9ead489470 | no |
| instance_type | The instance type | string | t2.micro | no |
| key_name | The key pair key name | string | null | yes |
| max_instances_size | Max autoscaling instances capacity | number | 4 | no |
| min_instances_size | Minimum autoscaling instances capacity | number | 2 | no |
| instance_port | Instances http port | number | 8080 | no |
| user_data_file | The file (.sh) which contain the start shell script | string | null | yes |
| vpc_id | The vpc id | string | null | yes |
| lb_subnet_ids | List of load balancer subnets id | list(string) | null | yes |
| instance_subnet_ids | List of instances subnets id | list(string) | null | yes |


## Outputs

| Name | Description |
|------|-------------|
| web_app_url | The url to access the web_app |


## DevInfos:
- Name: James Artur (Thunder);
- A DevOps and infrastructure enthusiastics.
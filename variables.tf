variable "app_name" {
    type    = string
}
variable "environment" {
    type = string
    default = ""
}
variable "managed_by" {
    type = string
    default = ""
}

#__________INSTANCES_________________#

variable "image_id" {
    type    = string
    default = "ami-08c40ec9ead489470"
}

variable "instance_type" {
    type    = string
    default = "t2.micro"
}

variable "key_name" {
    type    = string
}

variable "max_instances_size" {
    type    = number
    default = 4
}

variable "min_instances_size" {
    type    = number
    default = 2
}

variable "instance_port" {
    type    = number
    default = 8080
}

variable "user_data_file" {
    type        =string
    description = "Shell script file to run on start"
}

#________________VPC___________________#
variable "vpc_id" {
    type = string
}

variable "lb_subnet_ids" {
    type        = list(string)
    description = "List of subnets ID's for load balancer"
}

variable "instance_subnet_ids" {
    type        = list(string)
    description = "List of subnets ID's for instances"
}
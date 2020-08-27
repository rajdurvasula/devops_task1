variable "instance_type" {
  default = "t2.micro"
}

variable "rhel_inst_count" {
  type = number
  default = 1
}

variable "key_pair_name" {
  default = "ibm-rd-sing-kp2"
}

variable "private_key" {
  default = "/tform_ws/ibm_aws_squid/ibm-rd-sing-kp2"
}

variable "my_vpc_id" {
  default = "vpc-879dbfe0"
}

variable "my_subnet_id" {
  default = "subnet-6ad4c20d"
}

variable "subnetCIDRBlock" {
  default = "172.31.16.0/20"
}

variable "egressCIDRBlock" {
  default = "0.0.0.0/0"
}

variable "ingressCIDRBlock" {
  default = "122.179.67.134/32"
}

variable "my_vpc_security_groups" {
  type = map
  default = {
    name = "rd-sg-demo"
    description = "Demo Security Group by RD"
  }
}

variable "ansible_user" {
  default = "ec2-user"
}

variable "my_region" {
  type = string
  default = "ap-southeast-1"
}

variable "rhel8_regional_ami" {
  type = map 
  default = {
    ap-southeast-1 = "ami-04a2d6660f1296314"
  }
}

variable "win2016_regional_ami" {
  type = map
  default = {
    ap-southeast-1 = "ami-0c9be38028c474d31"
  }
}

variable "my_tags" {
  type = map
  default = {
    Owner  = "rd"
    Project = "On-boarding_Automation" 
    Location = "Singapore"
  }
}


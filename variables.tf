variable "project_region" {
  description = "Region project is built in"
  type        = string
}

variable "project_tag_name" {
  description = "Name of the project"
  type        = string
}


variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}





variable "public1_subnet_cidr" {
  type = string
}

variable "public2_subnet_cidr" {
  type = string
}

variable "private1_subnet_cidr" {
  type = string
}

variable "private2_subnet_cidr" {
  type = string
}
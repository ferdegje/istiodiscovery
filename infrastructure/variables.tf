variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "region" {
  default = "eu-west-2"
}
variable "project_name" {
  default = "ISTIO Discovery"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "size_of_cluster" {
  default = 4
}

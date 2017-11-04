variable "availability_zones" {
  type = "map"

  default = {
    eu-west-2 = ["eu-west-2a", "eu-west-2b"]
  }
}

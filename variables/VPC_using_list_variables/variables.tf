variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "vpccidr" {
  type        = string
  default     = "10.1.0.0/24"
  description = "CIDR Of VPC "
}

variable "publicssubentscidrs" {
  type    = list(string)
  default = ["10.1.0.0/26", "10.1.0.64/26"]
}

variable "privatesubentscidrs" {
  type    = list(string)
  default = ["10.1.0.128/26", "10.1.0.192/26"]
}

variable "commantags" {
  type = map(string)
  default = {
    "ProjectName" = "Demo",
    "Environmet"  = "Dev"
  }
  description = "Comman Tags"
}

variable "enable_dns_support" {
  type    = bool
  default = true
}

variable "aws_availabilty_zones" {
  type    = list(string)
  default = ["ap-south-1a", "ap-south-1b"]
}
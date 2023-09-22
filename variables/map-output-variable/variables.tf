
variable "instanceType" {
    type = string
    default = "t2.micro"
  
}

variable "awsRegion" {
    type = string
    default = "ap-south-1"
  
}

variable "osType" {
    type = string
    default = "redhat"

}

variable "amiIdMap" {
    type = map(string)
    default = {
      "redhat" = "value"
      "ubuntu" = "value"
      "amazon" = "value"
      
    }   
  
}

variable "commonTags" {
    type = map(string)
    default = {
      "Environent" = "Dev"
      "project" = "my project"
    }
  
}
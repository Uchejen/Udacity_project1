variable "prefix" {
  description = "this will be used for all resources in this server"
  default     = "Project1"
}

variable "username" {
  description = "this is the username of the vm"
  default     = "TerraformProject"
}

variable "password" {
  description = "this is the password of the vm"
  default     = "passwordTerra1234@"
}

variable "tagname" {
  description = "this is the name of the tag on every resource"
  default = {
    Environment = "Project1"
  }
}

variable "vmnumber" {
  description = "this gives the numver of Vms you want to deploy"
  default     = 2
}
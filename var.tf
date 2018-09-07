variable "region" {
 default = "us-east-1"
}
variable "vpc" {
  default = "10.0.0.0/16"
}
variable "pub-subnet" {
  type ="list"
  default = ["10.0.1.0/24","10.0.2.0/24"]
}
variable "pri-subnet" {
  type = "list"
  default = ["10.0.3.0/24","10.0.4.0/24"]
}

variable "pubazs" {
  type = "list"
  default = ["us-east-1e","us-east-1c"]
}

variable "priazs" {
  type = "list"
  default = ["us-east-1b","us-east-1a"]
}

variable "sub-id"{
  default = "subnet-075dbaec2e65c4a5d"
}


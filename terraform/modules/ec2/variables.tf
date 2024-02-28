variable "sg_id" {
  description = "SG ID for EC2"
  type = string
}

variable "subnets" {
  description = "Subnets for EC2"
  type = list(string)
}

variable "ec2_names" {
    description = "EC2 names"
    type = list(string)
    default = ["WebServer1", "WebServer2"]
}

variable "key_name" {
  description = "Key name for EC2"
  type = string
}

variable "private_key_path" {
  description = "Key full path"
  type = string
}

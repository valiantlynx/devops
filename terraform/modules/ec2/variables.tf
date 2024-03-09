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
    default = ["devops1"] # e.g ["devops1", "devops2"]
}

variable "key_name" {
  description = "Key name for devops EC2"
  type = string
}

variable "private_key_path" {
  description = "Key full path"
  type = string
}

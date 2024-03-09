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
    default = ["altlokalt1"] # e.g ["altlokalt1", "altlokalt2"]
}

variable "key_name" {
  description = "Key name for altlokalt EC2"
  type = string
}

variable "private_key_path" {
  description = "Key full path"
  type = string
}

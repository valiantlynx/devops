resource "aws_instance" "web" {
  count = length(var.ec2_names)
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  associate_public_ip_address = true
  vpc_security_group_ids = [var.sg_id]
  subnet_id = var.subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = var.ec2_names[count.index]
  }
}

data "template_file" "inventory" {
  template = <<-EOT
    [ec2_instances]
    %{ for ip in aws_instance.web.*.public_ip ~}
    ${ip} ansible_user=ubuntu ansible_ssh_private_key_file=${path.module}/${var.key_name}
    %{ endfor ~}
    EOT
}

resource "local_file" "dynamic_inventory" {
  filename = "${path.module}/dynamic_inventory.ini"
  content  = data.template_file.inventory.rendered
}

resource "null_resource" "run_ansible" {
  depends_on = [local_file.dynamic_inventory]

  provisioner "local-exec" {
    command = "ansible-playbook -i ${self.triggers.inventory_file} ../../../ansible/deploy-app.yml"
    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }
    working_dir = path.module
  }

  triggers = {
    inventory_file = local_file.dynamic_inventory.filename
  }
}
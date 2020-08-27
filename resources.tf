# AWS connectivity
provider "aws" {
  version = "~> 2.0"
  region = var.my_region
}

# Create Security Group
resource "aws_security_group" "my_sg" {
  vpc_id = var.my_vpc_id
  name = "${lookup(var.my_vpc_security_groups, "name")}"
  description = "${lookup(var.my_vpc_security_groups, "description")}"

  # Allow Ingress for SSH
  ingress {
    cidr_blocks = [ "${var.ingressCIDRBlock}" ]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  # Allow egress on all ports
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "${var.egressCIDRBlock}" ]
  }
  tags = var.my_tags
}

# Create RHEL8 Instance for testing
resource "aws_instance" "rhel8_client" {
  ami = "${lookup(var.rhel8_regional_ami, var.my_region)}"
  count = 1
  instance_type = var.instance_type
  key_name = var.key_pair_name
  vpc_security_group_ids = [ aws_security_group.my_sg.id ]
  subnet_id = var.my_subnet_id
  tags = "${merge({"Name"="rhel8_client"}, var.my_tags)}"

  provisioner "remote-exec" {
    inline = [ "echo 'Hello World'" ]
    connection {
      type = "ssh"
      user = var.ansible_user
      host = "${aws_instance.rhel8_client[count.index].public_ip}"
      private_key = "${file(var.private_key)}"
    }
  }

  provisioner "local-exec" {
    command= <<EOC
    sleep 30;
    >ansible.cfg;
      echo "[defaults]" | tee -a ansible.cfg;
      echo "host_key_checking = False" | tee -a ansible.cfg;
    EOC
  }

  provisioner "local-exec" {
    command = <<EOT
    sleep 30;
    >test_client.ini;
      echo "[test_client]" | tee -a test_client.ini;
      echo "${aws_instance.rhel8_client[count.index].public_ip} ansible_user=${var.ansible_user} ansible_ssh_private_key_file=${var.private_key}" | tee -a test_client.ini;
    ansible-playbook -i test_client.ini playbooks/install_apache.yml
    EOT
  }
}


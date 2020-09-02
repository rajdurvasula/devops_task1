output "server_ip" {
  value = "${aws_instance.rhel8_client.0.public_ip}"
}

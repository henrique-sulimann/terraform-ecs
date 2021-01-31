resource "aws_network_interface" "multi_ip" {
  subnet_id = "subnet-e62434ba"
  private_ips = [ "172.31.32.20", "172.31.32.21" ]
}

resource "aws_eip" "eip" {
  vpc = true
  network_interface = "${aws_network_interface.multi_ip.id}"
  associate_with_private_ip = "172.31.32.20"
}

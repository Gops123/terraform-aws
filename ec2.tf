resource "aws_security_group" "votebashsg" {
  name        = "votebash"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.votebash.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "votebash" {
  ami = "ami-04169656fea786776"
  instance_type = "t2.micro"
  subnet_id = "${var.sub-id}"
 associate_public_ip_address = "true" 
  security_groups = ["${aws_security_group.votebashsg.id}"]
  key_name = "gops1"
  tags {
    Name = "votebash"
  }
}



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


resource "aws_security_group" "elbsg" {
  name        = "elb"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.votebash.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_elb" "web" {
  name = "elb-vote"
  subnets = ["${element(aws_subnet.pub-Subnet.*.id, count.index)}"]
  security_groups = ["${aws_security_group.elbsg.id}"]

  listener {
    instance_port     = 8079
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }


  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    target              = "HTTPS:443/"
    interval            = 30
  }

  instances                   = ["${aws_instance.votebash.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
}


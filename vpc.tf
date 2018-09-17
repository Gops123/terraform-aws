resource "aws_vpc" "votebash" {
  cidr_block = "${var.vpc}"
  instance_tenancy = "default"
  tags {
    Name = "votebash"
  }
}


resource "aws_subnet" "pub-Subnet" {
  count      = "${length(var.pubazs)}"
  vpc_id     = "${aws_vpc.votebash.id}"
  cidr_block = "${element(var.pub-subnet,count.index)}" 
  tags = {
    Name = "pub-Subnet-${count.index+1}"
  }
}


resource "aws_subnet" "pri-Subnet" {
  count      = "${length(var.priazs)}"
  vpc_id     = "${aws_vpc.votebash.id}"
  cidr_block = "${element(var.pri-subnet,count.index)}" 
  tags = {
    Name = "pri-Subnet-${count.index+1}"
  }
}


resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.votebash.id}"

  tags {
    Name = "IGW"
  }
}

resource "aws_route_table" "public-rt" {
  vpc_id = "${aws_vpc.votebash.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "Public Subnet RT"
  }
}

resource "aws_route_table_association" "public-rt" {
  count = "${length( var.pubazs)}"
  subnet_id = "${element(aws_subnet.pub-Subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.public-rt.id}"
}



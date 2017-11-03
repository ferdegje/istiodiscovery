resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr}"

  tags {
    Name = "${var.project_name}"
    Project = "${var.project_name}"
  }
}

resource "aws_internet_gateway" "gw" {
    vpc_id = "${aws_vpc.main.id}"

    tags {
      Name = "${var.project_name}"
      Project = "${var.project_name}"
    }
}

resource "aws_subnet" "public" {
  vpc_id = "${aws_vpc.main.id}"

  count = 2

  cidr_block = "${cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)}"
  availability_zone = "${element(var.availability_zones[var.region], count.index)}"

  tags {
    Name = "${var.project_name} - Public - ${element(var.availability_zones[var.region], count.index)}"
    Project = "${var.project_name}"
    Type = "Public"
  }
}

resource "aws_subnet" "private" {
  vpc_id = "${aws_vpc.main.id}"

  count = 2

  cidr_block = "${cidrsubnet(aws_vpc.main.cidr_block, 8, 2+count.index)}"
  availability_zone = "${element(var.availability_zones[var.region], count.index)}"

  tags {
    Name = "${var.project_name} - Private - ${element(var.availability_zones[var.region], count.index)}"
    Project = "${var.project_name}"
    Type = "Private"
  }
}

resource "aws_eip" "nat" {
  count = 2
}

resource "aws_nat_gateway" "nat" {
  count = 2
  allocation_id = "${aws_eip.nat.*.id[count.index]}"
  subnet_id     = "${aws_subnet.private.*.id[count.index]}"

  tags {
    Name = "${var.project_name} - ${element(var.availability_zones[var.region], count.index)}"
    Project = "${var.project_name}"
  }
}

resource "aws_route_table" "r" {
  vpc_id = "${aws_vpc.main.id}"

  count = 2

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat.*.id[count.index]}"
  }

  tags {
    Name = "${var.project_name} - ${element(var.availability_zones[var.region], count.index)}"
    Project = "${var.project_name}"
  }
}

resource "aws_route_table_association" "a" {
  count = 2
  subnet_id      = "${aws_subnet.private.*.id[count.index]}"
  route_table_id = "${aws_route_table.r.*.id[count.index]}"
}

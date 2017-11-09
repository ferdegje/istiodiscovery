data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "kubernetes" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"

  count = "${var.size_of_cluster}"

  security_groups = ["${aws_security_group.public.id}"]
  subnet_id = "${aws_subnet.public.*.id[count.index%2]}"

  key_name = "${var.ec2_key_name}"

  tags {
    Name = "${var.project_name} - K8s - ${count.index}/${var.size_of_cluster}"
    Project = "${var.project_name}"
  }
}

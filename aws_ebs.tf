resource "aws_ebs_volume" "volume_test" {
  availability_zone = "us-east-1a"
  size              = 20

  tags = {
    Name = "test"
  }
}

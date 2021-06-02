resource "aws_instance" "sample_instance" {
  ami = "ami-0d5eff06f840b45e9"
  associate_public_ip_address = true
  instance_type = "t2.micro"
  key_name = "terraform-key"
  tags = {
    "Name" = "Test-VM"
  }
}
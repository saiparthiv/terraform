# Specify the key name to use for SSH access (adjust to your own key pair)
resource "aws_key_pair" "dove-key" {
  key_name   = "dovekey"
  public_key = file("dovekey.pub")
}

# Define the EC2 instance resource
resource "aws_instance" "example" {
  ami           = var.aws_amis
  instance_type = var.aws_instance_type
  key_name      = aws_key_pair.dove-key.key_name


  # Security group
  vpc_security_group_ids = ["sg-0623636f219772a1a"]

  # Example: tags for the instance
  tags = {
    Name  = "Launched By Terraform"
    Tools = "Terraform"
  }

  provisioner "file" {
    source      = "web.sh"
    destination = "/tmp/web.sh"
  }

  provisioner "remote-exec" {

    inline = [
      "chmod +x /tmp/web.sh",
      "sudo /tmp/web.sh"
    ]
  }

  connection {
    user        = "ubuntu"
    private_key = file("dovekey")
    host        = self.public_ip
  }
}

output "PublicIP" {
  value = aws_instance.example.public_ip
}

output "PrivateIP" {
  value = aws_instance.example.private_ip
}

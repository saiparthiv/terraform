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

resource "aws_eks_cluster" "aws_cluster" {
  name     = "my-cluster"
  role_arn = "arn:aws:iam::123456789012:role/eks-service-role-AWSServiceRoleForAmazonEKS-74d3c911-af7b-4b3e-bf7d-1f5d6b6e1ef3"
  version  = "1.14"
  vpc_config {
    subnet_ids = ["subnet-0e8f3d6b1b4b4b1b4", "subnet-0e8f3d6b1b4b4b1b4"]
  }
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t4.micro"
}

output "PublicIP" {
  value = aws_instance.example.public_ip
}

output "PrivateIP" {
  value = aws_instance.example.private_ip
}

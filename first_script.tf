# Define the provider for AWS
provider "aws" {
  region = "us-east-1" # Change this to your desired AWS region
}

# Define the EC2 instance resource
resource "aws_instance" "example" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t3.micro"

  # Specify the key name to use for SSH access (adjust to your own key pair)
  key_name = "web-dev-key"

  # Security group
  vpc_security_group_ids = ["sg-0623636f219772a1a"]

  # Example: tags for the instance
  tags = {
    Name  = "Launched By Terraform"
    Tools = "Terraform"
  }
}

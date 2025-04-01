resource "aws_instance" "Ec2Instance" {
  ami 							            = "ami-0ed752ea0f62749af"
  disable_api_termination       = true
  instance_type 				        = "t2.micro"
  associate_public_ip_address 	= false
  subnet_id 					          = "subnet-0c1a9d3194d60eb18"
  vpc_security_group_ids 		    = ["sg-04aee56850429ec62"]

   user_data = <<-EOF
  #!/bin/bash
  sudo apt-get update
  sudo apt-get install -y apache2
  sudo systemctl start apache2
  sudo systemctl enable apache2
  echo "The page was created by the user data" | sudo tee /var/www/html/index.html
  EOF 

  root_block_device {
    encrypted = true
  } 

  tags = {
    Name = "mywebserver"
  }
}

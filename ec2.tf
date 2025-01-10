# Get the latest recommended ECS-optimized AMI ID
data "aws_ssm_parameter" "ecs_optimized_ami_id" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux/recommended/image_id"
}

resource "aws_launch_template" "ecs_lt" {
  name_prefix = "ecs-lt"

  # Use the retrieved ECS-optimized AMI ID
  image_id = data.aws_ssm_parameter.ecs_optimized_ami_id.value

  instance_type = "t2.micro"

  key_name = "ec2-keypair"
  vpc_security_group_ids = [aws_security_group.security_group.id]

  iam_instance_profile {
    name = "AWS-EC2role"
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 30
      volume_type = "gp2"
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "ecs-instance"
    }
  }
user_data = filebase64("${path.module}/ecs.sh")
}



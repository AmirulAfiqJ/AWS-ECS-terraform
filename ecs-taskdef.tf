resource "aws_ecs_task_definition" "ecs_task_definition" {
  family = "my-ecs-taskdef"
  network_mode = "awsvpc"
  execution_role_arn = "arn:aws:iam::831926588318:role/AWS-EC2role" #needs to change
  cpu = 256
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture = "X86_64"
  }
  container_definitions = jsonencode([
    {
    name = "docker-demo"
    image = "831926588318.dkr.ecr.us-east-1.amazonaws.com/start-docker:latest" #needs to change
    cpu =  64
    memory = 128
    essential = true
    portMappings = [
      {
        containerPort = 80
        hostPort = 80
        protocol ="tcp"
      }
    ]
    
  }])
}
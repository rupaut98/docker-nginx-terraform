resource "aws_ecs_cluster" "main_cluster" {
    name = "main_cluster"
}

resource "aws_ecs_task_definition" "task_definition" {
    family = "service"
    network_mode = "bridge"


    execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
    container_definitions = jsonencode([
        {
            name = "first"
            image = "677276109734.dkr.ecr.us-west-2.amazonaws.com/app/task-app:latest"
            cpu = "10"
            memory = "512"
            essential = true
            portMappings = [
            {
                containerPort = 80
                hostPort = 80
            }
             ]
        },
    ])
}

resource "aws_iam_role" "ecs_task_execution_role" {
    name = "ecs_task_execution_role"

    assume_role_policy = jsondecode({
        Version = "2012-10-17"
        Statement = [
            {
                Action : "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "ecs-tasks.amazonaws.com"
                }
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_service" "ecs_service" {
    name = "ecs-service"
    cluster = aws_ecs_cluster.main_cluster.id
    task_definition = aws_ecs_task_definition.task_definition.arn
    launch_type = "EC2"

    network_configuration {
      subnets = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
      security_groups = [aws_security_group.rds_sg.id]
    }

    desired_count = 1
}
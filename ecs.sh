#!/bin/bash

# Ensure the directory exists
mkdir -p /etc/ecs

# Configure the ECS agent
cat <<EOF > /etc/ecs/ecs.config
ECS_CLUSTER=my-ecs-cluster
ECS_AVAILABLE_LOGGING_DRIVERS=["json-file","awslogs"]
ECS_DOCKER_API_VERSION=1.24
ECS_ENGINE_AUTH_TYPE=docker
EOF

# Restart the ECS agent to apply changes
systemctl restart ecs

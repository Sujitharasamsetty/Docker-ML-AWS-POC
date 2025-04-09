#!/bin/bash

REGION="us-east-1"
APP_NAME="iris-fastapi-app"
STACK_NAME="iris-fargate-stack"

echo "1. Creating ECR repo (if not exists)..."
aws ecr describe-repositories --repository-names $APP_NAME --region $REGION 2>/dev/null ||
aws ecr create-repository --repository-name $APP_NAME --region $REGION

ECR_URI="$(aws ecr describe-repositories --repository-names $APP_NAME --region $REGION --query 'repositories[0].repositoryUri' --output text)"

echo "2. Building Docker image..."
docker build -t $APP_NAME .

echo "3. Logging into ECR..."
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin "$ECR_URI"

echo "4. Pushing Docker image to ECR..."
docker tag $APP_NAME:latest "$ECR_URI:latest"
docker push "$ECR_URI:latest"

echo "5. Deploying CloudFormation stack..."
aws cloudformation deploy \
  --template-file cloudformation.yaml \
  --stack-name $STACK_NAME \
  --capabilities CAPABILITY_NAMED_IAM \
  --region $REGION \
  --parameter-overrides AppName=$APP_NAME

echo "6.ECS Fargate app is deployed."

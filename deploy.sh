#!/bin/sh -e

AWS_REGION="ap-southeast-2"
AWS_ACCOUNT="<myaccountid>"

APP_NAME="dbapp"
APP_VERSION="v1.0"


# create ruby rails app image on ECR
cd 3-ruby-app
# build image
docker build . -t ${APP_NAME}:${APP_VERSION}

aws ecr get-login-password \
    --region $AWS_REGION | docker login \
    --username AWS \
    --password-stdin ${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com

# create repo, when repo is not ready
aws ecr create-repository \
    --repository-name ${APP_NAME} \
    --image-scanning-configuration scanOnPush=true \
    --region ${AWS_REGION}

docker tag ${APP_NAME}:${APP_VERSION} \
    ${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com/${APP_NAME}:${APP_VERSION}

docker push ${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com/${APP_NAME}:${APP_VERSION}


# create VPC
cd 1-vpc
terraform init
terraform validate
terraform plan
terraform apply


# create EKS cluster
cd 2-eks-cluster
terraform init
terraform validate
terraform plan
terraform apply

# deploy the ruby app
export KUBECONFIG=`ls . | grep kubeconfig`
kubectl get nodes

# deploy app in default namespace
kubectl run dbapp --image=${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com/${APP_NAME}:${APP_VERSION} 

kubectl get pods


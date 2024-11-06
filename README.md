
# infra-for-ruby-app
This repo is for a case study, of creating AWS VPC & EKS resources, and a Simple Ruby on rails app for Database connection.

## The `vpc` component 
- It creates an AWS VPC with:
- 3 public subnets
- 3 private subnets
- 3 NAT gateways
- and internet gateway, relevant route tables, routes etc.
- Code has been tested working.

## The `eks-cluster` component 
- It creates a very basic AWS EKS cluster, using eks module provided by Hashicorp
- refer to: https://github.com/terraform-aws-modules/terraform-aws-eks
- Code has been tested working.

## The `ruby-app` component 
- It creates a basic Ruby on Rails app Docker image
- The app includes a short code sample for SQL database connection.
- Output of this component is a Docker image for the Ruby on rails app, which can be stored on Docker hub or AWS ECR etc.
- Code is not fully tested.

## The `deploy.sh` script
- It is a list of steps to create resources and deploy the app.

## Prerequisite of creating and using resourses in this repo
#### Installation
- terraform (>=0.12)
- docker (>=19)
- awscli (>=1.19)
- eksctl (>=0.28)
- kubectl (>=1.18)

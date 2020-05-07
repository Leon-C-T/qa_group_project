# qa_group_project README

## Table of Contents

1. [Project Brief](#project-brief)
    + [Proposal](#proposal)
2. [Trello Board](#trello-board)
    + [MoSCoW Analysis](#moscow-analysis)
    + [Start Point](#start-point)
    + [Rolling Changes](#rolling-changes)
    + [End Point](#end-point)
3. [Risk Assessment](#risk-assessment)
    + [Budgeting](#budgeting)
4. [Project Architecture](#project-architecture)
    + [Architecture Diagram](#overall-architecture)
    + [Issues Encountered](#issues-encountered)
5. [Design Considerations](#design-considerations)
    + [Amazon Services](#amazon-services)
    + [Project Extensions](#project-extensions)
6. [Testing](#testing)
    + [Local Testing](#local-testing)
7. [Deployment](#deployment)
    + [Toolset](#toolset)
    + [CI Server Implementation](#ci-server-implementation-and-configuration)
    + [Security](#security)
    + [Branch and Merge Log](#branch-and-merge-log)
8. [Improvements for Future Versions](#improvements-for-future-versions)
9. [Installation and Setup Guide](#installation-and-setup-guide)
+ [Authors](#authors)
+ [Acknowledgements](#acknowledgements)


### EKS Fargate Serverless Solution

1. Clone Serverless Repositary
    - ```git clone https://github.com/THC-QA/qa_group_project.git -b serverless```

2. To make fargate cluster (Note: must be in eu-west-1 or other fargate availabe regions)
    - Get awscli https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html and configure with user credentials that have enough user permissons to run following commands
    - Get eksctl https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html

    - ```aws configure```
    - ```eksctl create cluster --cluster-name --fargate```

3. Go to enironments eu-west-1 folder fill in the inputs.tf then run the following commands to get and RDS database and CodeBuild
    - ```terraform init```
    - ```terraform plan```
    - ```terraform apply```


4. (Skip to step 6 if you followed step 3 to create an RDS database and CodeBuild) 
    - Create a publicly accessible RDS database
    - Initialise database name as petclinic in additional configuration to create a database called be petclinic in the instance
    
5. Create Code Build - Setup
    - Repositary https://github.com/THC-QA/qa_group_project.git the branch as serverless
    - Spec: Linux-Ubuntu-3GB memory 2vCPU-Standard3.0
    - BuildSpec: build-spec.yaml

6. For the Code Build we still have to add environment variables
Get ALBINGRESSCONTROLLEIAMPOLICY arn, if it doesn't already exist in your account you can create it through awscli
```
aws iam create-policy \
   --policy-name ALBIngressControllerIAMPolicy \
   --policy-document https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/iam-policy.json
```

| Key       | Value       |
| ------------- |:-------------:|
| AWS_ACCESS_KEY_ID     | Enter Credentials that has access to Eks Cluster |
| AWS_SECRET_ACCESS_KEY      | Enter Your Secret Access Key      |
| ALBIngressControllerIAMPolicy | aws:iam::xxxxxxxxxxx:policy/ALBIngressControllerIAMPolicy     |
| vpc | vpc-xxxxx of cluster      |
|cluster_name | cluster name      |
| url | endpoint of RDS Database      |
| username | RDS username      | 
| password | RDS password|

7. Run CodeBuild
    - You can rune Kubectl get Ingress to get public dns of the website
    
    
 NOTE: You're Ingress may not automatically connect to the load balancer as it could fail due the frontend and backend not running
 already by the time you create the ingress, to remedy this you could either manually delete the ingress with ```kubectl delete ingress ingress-connect``` and recreate it after the pods are running with ```kubectl apply -f kube-serv/ingress-service-am.yaml``` the other method is to put the sleep timer 2 - 5 minutes before creating the ingress this can be done on the build-spec.yaml file line 57

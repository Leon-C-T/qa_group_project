# README
---
# PetClinic WebApp Deployment

Written in reference to QAC - Final Project Brief (DevOps). This project is for the purpose of fulfilling the specification definition for the project assignment due Week 12 of the DevOps February 17 2020 intake cohort. The official working title of the project is Final Project (group), often reformatted to qa_group_project for tagging purposes.

_**To view the presentation for this project, click [here](linkpending.**_

#### License

```Copyright (C) 2020  THC-QA, thenu97, Amran-Lab, Leon-C-T

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
```

**If you're trying to install this project, and are disinterested in its creation and background, find the installation guide link in the table of contents, or follow it [here](#installation-and-setup-guide).**

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
    + [Individual Showcases](#individual-showcases)
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

## Project Brief

The following two repositories are to be deployed:

+ A frontend webapp coded in [angular js](https://github.com/spring-petclinic/spring-petclinic-angular).
+ A [restful backend API](https://github.com/spring-petclinic/spring-petclinic-rest) coded in java.

The deployment and development workflows of this service must be automated with reference to the following considerations:

1. Which of the tools encountered over the training period are best suited to the task?
2. Multi-environment support to enable testing.
3. Automated building and deployment based on version-control server changes.
4. Management of running costs.

### Proposal

Our proposal focused on the creation of an automated workflow focusing on the following core architecture:

+ Infrastructure as code deployment using Terraform.
+ Infrastructure configuration using Ansible.
+ A Jenkins server functioning in a CI/CD capacity, webhooked to this repository.
+ A Kubernetes cluster running the app.
+ Monitoring of the project using AWS tools such as CloudWatch.
+ A basic SRE focussed design incorporating serverless backup and recovery functions.

![An initial look at a simplified project architecture](https://i.imgur.com/vzR9JnO.png)

This shows intial architecture plan was sketched during the first team standup. Note the colour assignment showing our extensions of the core brief.

Green demonstrates a *true* MVP for the project. A single Jenkins server deploying to a manager and worker node. The architecture would be deployed manually using a terraform HCL application, the pipeline would deploy a containerised application using Kubernetes. Nodes would be configured using ansible, and balanced/scaled using basic EC2 functionality.

Black demonstrates our inital understanding of our proposal for the project. Terraform would deploy a Jenkins server and an EKS cluster. The Jenkins server would automate deployment updates and deploy a containerised application to EKS.

Orange and red represent two stages of our proposed expansion, the inclusion of lambda functions to manage backup and restoral.

## Trello Board

We used a kanban board on Trello to manage my workflow during the project, the board was set to public to enable group work and display. Agile methodology was implemented in line with the brief in terms of product and task backlog. Due to the short nature of the project, the entire workflow was considered to constitute a single sprint. We organised ourselves with daily standups, and when split into subgroups, organised end of day retrospectives and merge meetings to coordinate workflow. At the end of the project a breakdown and retrospective session was scheduled.

Running parallel to the board's progressing, an evolving MoSCoW prioritisation analysis was started, as demonstrated below.

In service of our key deliverable, an automated deployment framework, items required from our proudct backlog were subdivided. These tasks, generated in the task backlog as required, could be moved across the board from 'in progress' to 'testing' during their development lifecycle. Delivery endpoints were designated 'Completed' or 'Bugs and Cancellations' depending on their eventual usefulness to the project. Reassessment of priorities was evaluated daily as a group; some items which were considered inefficient, or were superceded by more mature technologies, were abandoned.

### MoSCoW Analysis

#### Must Have

+ Fully version controlled architecture.
+ Webhooked CI/CD builds.
+ Deployment to multiple environments.
+ IaC automated provisioning.
+ Budgeting.

#### Should Have

+ Load balanced and auto scaling services.
+ All process flows automated.
+ Monitoring of services and infrastructure.
+ Mature use of available cloud technologies.
+ SRE and security conscious work approaches.

#### Could Have

+ Serverless function for backup.
+ Serverless function for backup maintenance.
+ Serveless function for instance recovery.
+ HTTPS certification as a security provision.
+ DNS allocated entrypoints.
+ Full traffic tracing provision.
+ Fully serverless architecture.

### Start Point

![A picture of the trello board, started on the first week. Only the product backlog has been added. No tasks have been entered.](https://i.imgur.com/Zd6LgI5.png)

At the start of the project, we focussed on our understanding of an initial project plan: Starting the Kanban board [itself](https://trello.com/b/ht0rcd4O/spring-pet-clinic-deployment), starting this documentation to streamline future workflow; instituting a github repository for the project, which can be found [here](https://github.com/THC-QA/qa_group_project); and initialising the risk assessment for the project in line with initial understandings.

Tasks seen on the board were colour coded in terms of urgency. The inital toolset was deemed sufficient to fulfil an MVP for the project brief, with the first wave of extensions planned to be the serverless recovery functionality, and fully serverless architecture.

### Rolling Changes

+ Choosing to use a provisioned EKS cluster changed the role of Ansible within the project. During deployment the only necessary configuration management target became the Jenkins server itself.
+ Imported the app to be deployed as git modules, and created a .gitignore system for the project. This enabled streamlining of the project size during initial development.
+ A branch plan was instituted to enable team subgroups to operate on independent features. To this end the project was split into a 'master' and 'dev' branch. The 'dev' branch was further subdivided into 'terraform' and 'jenkins' workflows, and the team split accordingly to maximise productivity and efficiency.
+ A module/environment structure was chosen for terraform to ensure that the project remained portable, and to encourage at will deployment to future environments or region zones. This ensured the infrastructure could be modular and extensible, and allowed easier future expansion.
+ The application was containerised, starting with the backend. Docker was chosen for this purpose as this was the toolset we were most familiar with and had the best free-tier utility.
+ The Jenkins pipeline was initialised, and an ansible module passed over to enable setup of the server.
+ An initial architecture was provisioned, with a EC2 instance to deploy Jenkins to, and an EKS cluster to deploy the finished containers to. To support this layout, the correct roles were assigned, and a VPC was created.
+ NGINX was used as a reverse proxy to connect the front and back ends during local deployment, and divert API calls appropriately. Issues were raised during local deployment, and solved by correct traffic redirection.
+ The updating of the terraform instance was reassessed, and Jenkins nodes dropped in favour of increased portability.
+ Difficulties were encountered in the linking of TFState files to the Ansible configuration.ini system. To circumvent this, Ansible was dropped from the project in favour of remote-exec installation instructions.
+ Security groups were instantiated as an independent module to better manage permission and traffic allocation within the project.
+ An initial local deployment was successful using Kubernetes, and testing of the pipline was started.
+ Issues with terminal and console linkage, including interfacing kubectl with Amazon CLI.
+ Lambda functions were started, starting with automated snapshots.
+ NGINX was used as a load balancer for the EKS cluster.
+ Lambda and CloudWatch modules were added to the terraform plan in order to service the newly created lambda functions. Triggers were set in a mix of scheduled cron jobs and CPUUtilisation triggers.
+ Lambda functions for snapshot image handling, and recovery were built.
+ Cloudwatch dashboard was troubleshooted, as was the eks node group autoscaler.
+ Conflicts were discovered with the recently instituted AWS Data Lifecycle manager, leading to its inclusion as a project extension, and the necessity for a snapshot deletion lambda function. Due to the difficulty in deleting snapshots without first removing associated images, the image creation function was ammended to only permit a single image per target.
+ SNS topics were investigated to streamline function calls and to enable later automation of project monitoring reporting.
+ Amazon Fargate was intialised in the first step toward a fully serverless alternate solution to the project architecture.

### End Point

![A picture of the endpoint of the Trello KanBan board, shortly before the presentation](awaiting link

EXPLANATION OF ENDPOINT

#### What Went Well

+ IaC enabled broad deployment with a region agnostic approach.
+ Pipeline functioned well in both an automated capacity and for multi-environment deployment.
+ Multifarious usage of Amazon curated services.
+ Multi-implementation of serverless solutions

#### What Could Be Improved

+ Little usage was found for configuration management in a project of this scale.
+ CloudTrail user tracking was not implemented for the project.
+ The testing functionality explained in the submodule README could not be implemented, after outside assistance, no solution could be found.

## Risk Assessment


|Risk No.|Risk|Description|Hazard|Likelihood|Impact|Solution|
|---|---|---|---|---|---|---|
|1.0.1|Overrun on time.|Due to poor time management, the project is not completed.|Worst case scenario, marks are lost due to lack of coverage of brief.|2|5|Make good use of Kanban to manage workflow, and efficient time use of office resources.|
|1.0.2|Overrun on budget.|Available budget is consumed.|Worst case scenario, we incur out of pocket expenses and are not reinbursed.|3|5|Implement budget warnings on AWS, daily monitoring of expenditure.|
|1.0.3|Catch coronavirus.|Due to illness, significant amounts of workhours are lost.|Worst case scenario, the remaining team are overburdened.|4|3|Avoid human contact, follow NHS best practice.|
|1.0.4|Leak of login or key details.|Credentials are version controlled or misplaced.|Worst case scenario, all data is accessible to malicious actors.|3|4|Protect personal data, make use of ignore files and DevSecOps best practices.|
|1.1.1|Corruption or conflict of respository branches.|Due to team cooperation on a single repository, mismanagement of branches could occur.|Worst case scenario, data lost.|5|4|Make full use of advanced git recovery techniques.|
|1.1.2.1|Infrastructure: TFState|Infrastructure management is impeded by terraform errors.|Worst case scenario, impedement to workflow.|2|2|Familiarisation with terraform cli.|
|1.1.2.2|Infrastucture: Networking|Connections between modules are non-functional but not errors.| Worst case scenario, project modules fail to initialise or communicate.|3|4|Check-off new infrastructure status using AWS web GUI.|
|1.1.2.3|Infrastructure: Permissions|Mismanagement of keys or roles enables malpractice.|Worst case scenario, vulnerabilites are introduced into security practices.|2|5|Roles and Users are only allowed relevant permissions, and key handling and spread is minimised.|
|1.2.1|Kubernetes: networking|Application incorrectly networked.|Worst case scenario, application fails to run.|3|5|Carefully research relevant documentation|
|1.2.2|Kubernetes: scaling|Application fails to scale.|Worst case scenario, application cannot be expanded on demand.|2|4|Correctly implement AWS monitoring and response.|
|1.3.1|Jenkins pipeline integration|Jenkins compatability with GitHub webhooks.|Worst case scenario builds are not triggered, resulting in inconsistent builds.|3|1|Maintain webhooks and pull/push requests, ensure branches merged correctly.|
|1.3.2|Jenkins server exposed.|Port 8080 open to webtraffic is poor working practice.|Worst case scenario, introduce systemic vulnerabilities into build server.|5|2|Set firewall rules to only allow specific access.|
|1.4.1|Lambda: triggers|Lambda functions cannot be correctly triggered.|Incomplete backup and recovery system for the project.|3|3|Investigate correct usage of CloudWatch and SNS.|
|1.4.2|Lambda: dependencies|Lambda functions fail to chain correctly.|Backup and recovery system has incomplete or chaotic functionality.|2|3|Creation and maintenance of multiple co-dependent lambda functions.|

![A risk assessment matrix for the beginning of the project](https://i.imgur.com/wEc3GkQ.png)

As the matrix demonstrates, at the beginning of the project, the majority of presumed risks were in the yellow band. This represents a medium level of combined risk, that requires ongoing management, and measures put in place to mitigate the effects. Those risks that were placed in the red band required additional levels of precaution and frequent monitoring.

After implementation of the proposed solutions from the first table, the results of the project are expanded upon below.

|Risk No.|Risk Occured|Effects|Incidences (days across 3 week span)|Impact|Proposed Revision|
|---|---|---|---|---|---|
|RISKS TO BE ADDED

There are A NUMBER potential takeaways from the discrepancies between the first and second risk assessments:

1. LIST OF DIFFERENCES

> _"QUOTE ABOUT RISKS"_

To further illustrate the renewed risk assessment, a modified risk matrix is displayed below.

![A risk assessment matrix for the completion of the project.](LINK PENDING

BRIEF DISCUSSION OF RISKS ENCOUNTERED

### Budgeting

The total budget for the completion of the project was £20. In order to prevent over spending a budget warning was created in Amazon Billing for 50%, and then 85% of available budget.

Tracking was conducted daily by the group, and brought up in both standups and retrospectives in order to ensure that no out-of-pocket expenses were incurred.

## Project Architecture

### Overall Architecture

#### Interaction and Services

This section aims to demonstrate how user interaction with the app is structured, as well as the interplay between the deployed containers.

![User interaction diagram showing kubernetes architecture.](https://i.imgur.com/59ezyMf.png)

As can be seen from the diagram, from a user perspective, they are only faced with the output of the frontend container, as balanced by the NGINX over the detailed EKS cluster. Nodes are scaled by terraform-set policy. NGINX also enables HTTPS authentication and dynamic traffic redirection

Pod replicas have been set at 3 due to hardware constraints on the available VMs.

Shown on the diagram is the connection between the backend container and the database. The usage of a non-local database is optional and is elaborated on in the documentation for the Spring Petclinic REST backend, as found [here](https://github.com/spring-petclinic/spring-petclinic-rest/tree/85bbca8bbe5ccb99efe0643f58ece55491ffec54).

#### Deployment

The pipeline for this project would be the customer facing deployment portal were the project to undergo handover to an operations and maintenance team. To show a typical look at the deployment pipeline, two diagrams are included below.

![Deployment CI/CD Diagram, showing typical process flow.](https://i.imgur.com/IXuXjy9.png)

As demonstrated in the diagram, the inclusion of a non-local database is optional, and would be created in an AWS RDS instance. This requires reworking of the backend container.

A multi-provider approach was considered, with use of a GCP SQL instance, however time constraints on the project did not allow this. It would have required the inclusion of customer and vpn gateways, and the networking of a tunnel between the two providers. A multi-provider solution would be a meaningful extension to the project, showcasing the flexibile business opportunities available in a competitive cloud market.

NGINX, listed as the tool used for 'live' production, is also a container, running as the load balancing service for the EKS cluster. It also serves as part of the https authentication system by way of traffic redirect.

The process flow chosen in this project mirrors closely that used by DevOps engineers in genuine enterprise environments, and to detail this, a full DevOps toolchain analysis is included below.

![DevOps toolchain and process flow diagram for project.](https://i.imgur.com/uItAJdW.png)

Our project includes the necessary functionality, by way of tool integration and feedback to be handed over to a team for operations and continued development. As mentioned, an extension of this project enables the use of a fully serverless deployment solution, shown here by the option of a AWS CodePipeline CI/CD process.

### Issues Encountered

+ Container interconnection failure.
+ NGINX integration issues.
+ Kubectl installation on Jenkins.
+ Kubectl interface with EKS.
+ Jenkins testing, particularly with REST documentation.
+ Lambda function permissions.
+ Lambda function depcrecated functionality.
+ Lambda function conflict with AWS Lifecycle Policy Manager.
+ Terraform lockstate issues.
+ Terraform ARN naming conventions.
+ Poor Amazon documentation.
+ Terraform AWS namespace interplay.
+ Terraform policy and role assignment issues.
+ CloudWatch JSON issues.

## Design Considerations

Over the course of our various extensions to the project we changed our structure, and committed to deep dives into various aspects of DevOps toolsets and practices. A highlight of these has been provided here.

### Amazon Services

Our understanding and depth of utilisation of AWS available services changed over the course of this project, and by the completion of our initial MVP we decided upon committing to a demonstration of two business approaches to deployment functionality. These can be broadly typecast as a 'traditional' in-house managed architectural setup vs. a 'serverless' solution. There are benefits to both but as a generalisation it represents the difference between a control-focussed vs. cost-optimised approach.

![Architectural diagram for our 'traditional' architecture](https://i.imgur.com/hg9sB4j.png)

This diagram shows the overall architecture deployed by the terraform portion of the project. All instances are networked within a VPC, which itself is comprised of two subnets. Most artifacts are present in both subnets, with the exception of the Jenkins instance, which only exists in one.

Cloudwatch, through a series of events and rules, implements our Lambda focussed snapshot and recovery chain. This is split into four principal components:

1. A rate event triggering every 6 hours.
    + This triggers a snapshot to be taken of the Jenkins instance.
2. A cron job ever day at 2200hrs.
    + This triggers deletion of snapshots over a day old.
3. The completion of a snapshot creation.
    + This triggers creation of a new machine image, and deletion of the previous one.
4. An alarm linked to the health of the Jenkins instance.
    + This calls an SNS topic.
        + This triggers the recreation of the Jenkins instance using the backup machine image.

The containers for the project are running as part of an EKS cluster, which autoscales the instances which make up its nodes. The balancer for the services is set as the NGINX instance, which auto-creates an Elastic Node Balancer as an interface.

![Architectural diagram for our 'serverless' solution](https://i.imgur.com/gqndBRq.png)

For the serverless version of this deployment, there is a noticeable increase in simplicity of design. This follows the hallmarks of provider managed serverless systems, and the move away from discrete resource provisioning. All infrastructure and codeware has been moved fully onto AWS systems, and some aspects of control more heavily managed by AWS itself. Of particular note is the replacement of the Jenkins server with CodePipeline, and the hosting of the containers by an ECS backed system.

The sole non-serverless item is the RDSConnect database, which is required for correct backend functionality of the deployed app.

### Individual Showcases

In the following section, specific snippets of the project have been highlighted by the group members, and their functionalities given a deep-dive insight. This allows the showcasing of effort that went into this deployment infrastructure, and provides an avenue for all team members to demonstrate their enthusiasm and output.

#### Leon: EKS Node Group

![Node group diagram](https://i.imgur.com/QMB637K.png)

A diagram showing the creation process flow for the EKS functionality within the terraform apply process architecture. The following being the code block actuating the process.

```resource "aws_eks_node_group" "petclinic_eks_nodegrp" {
  cluster_name    = aws_eks_cluster.petclinic_eks.name
  node_group_name = "Pet_Clinic_Node_Groups"
  node_role_arn   = aws_iam_role.pet_role_node.arn
  subnet_ids      = var.subnets
  instance_types  = ["${var.instance-type}"]

  scaling_config {
    min_size     = 1
    max_size     = 5
    desired_size = 1
  }
  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.pet-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.pet-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.pet-AmazonEC2ContainerRegistryReadOnly,
  ]
}
```

As one of the final architecture components to be initialised, the node group is highly dependent on preceding IaC processes. It demonstrates the flexibility and power of the utility, and offers some insights into the nature of resource creation within the AWS CLI framework.

This code within our terraform system creates an EKS node group within the cluster previously defined. This cluster is passed into the block as an argument in line 56, forming a connection. An IAM role which; allows connection to EKS clusters, allows management of network configuration of the nodes, and allows read-only access of the EC2 Container Registry Repository; is attached to the node group via the node_role_arn argument. The listing of the policies as dependencies ensures creation precedence and prevents build errors.

The authorised infrastructure is then placed within the project's VPC.

From a hardware perspective, the var.instance-type variable allows user toggling of hardware output for the node creation. A t2.small was used during testing to keep costs low, however the production system will utilise t3a.small instances in order to guarantee CPU and network performance.

The attached scaling group allows the scaling of the nodes in line with performance, as dictated by a scaling policy attached after the deployment of the resource. Odd numbers are chosen to allow quorum polling to take place in the event of instance health failure.

The node group sits within the EKS cluster and runs the production containers with the use of kubernetes. These containers are passed to the group by Jenkins executed CLI commands during the pipeline runtime. Vital to the deployment, without this provision, no pods could be deployed, and therefore no app could be delivered.

#### 

### UI

Potential logo

![NEW Logo](NEW PIXELART LOGO

#### Potential Expansions

ANYTHING WE DON'T MANAGE TO GET DONE

![Expanded architecture diagram.](EXPANDED OPERATIONAL FUNCTIONALITY

ENABLE SOME FEATURE

## Testing

### Local Testing

DESCRIPTION OF TESTING AND RELEVANT CODE BLOCK

### Final Report

ANALYSIS OF HOW TESTING COULD BE ACHIEVED OR HANDED OVER

## Deployment

### Toolset

As of 2020/05/06.

+ Git and GitHub
+ Communication and Admin:
    + Trello
    + LucidChart
    + Slack
    + MicrosoftTeams
+ Terraform
+ Ansible
+ Docker:
    + Docker
    + Compose
    + DockerHub
+ NGINX
+ Kubernetes
+ Jenkins
+ AWS:
    + CostExplorer
    + Billing
    + EC2
    + EBS
    + EKS
    + AutoScaling
    + CloudWatch
    + Lambda
    + IAM:
        + Roles
        + Policies
        + Users
        + Groups
    + Lifecycle Manager
    + SNS
    + VPC:
        + Security Groups
        + Subnets
        + Internet Gateway
        + Route Tables
    + Route 53
    + AWS Certificate Manager
    + CodePipeline:
        + CodeCommit
        + CodeBuild
        + CodeDeploy
    + Fargate
    + X-Ray

### CI Server Implementation and Configuration

JENKINS VS CODEPIPELINE WITH ANALYSIS OF PROCESSES FOR BOTH

### Security

EXHAUSTIVE LIST OF SECURITY PRECAUTIONS TAKEN, EMPHASISE DEVSECOPS

### Branch and Merge Log

Log at time of README update: polled Developer branch on PROJECT END

```SUBMISSION HISTORY
```

LIST OF GIT STRUCTURE, BRANCHES, COLLABORATION, AND FUNCTIONALITY

## Improvements for Future Versions

WHAT WE WANT TO ACHIEVE THAT WE DIDN'T MANAGE TO: A LIST

KANBAN FOR IMAGINED FUTURE SPRINT

![An imagined kanban board for the database sprint of an updated project](LINKTOFOLLOW

To pair with this imagined sprint, a potential risk assessment has been provided, in simplified form, below:

|Risk Code|Potential Risk|Potential Impact|Hypothetical Preventative Measure|
|---|---|---|---|
|FUTURE RISKS FOR FUTURE PEOPLE

## Installation and Setup Guide

1. EXHAUSTIVE LIST OF INSTALLATION STEPS

#### Authors

THC, thenu97, Amran-Lab, Leon-C-T - QA Academy Trainees.

#### Acknowledgements

A massive thank you to Syed, for fielding our endless questions, and WRITE SOMETHING ELSE

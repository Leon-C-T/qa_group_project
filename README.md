# README
---
# PetClinic WebApp Deployment

Written in reference to QAC - Final Project Brief (DevOps). This project is for the purpose of fulfilling the specification definition for the project assignment due Week 12 of the DevOps February 17 2020 intake cohort. The official working title of the project is Final Project (group), often reformatted to qa_group_project for tagging purposes.

_**To view the presentation for this project, click [here](https://docs.google.com/presentation/d/1w5ElbUm_zKdbT2KUwtO-kc3IhwYdiX78Gipt7SVR4PA/edit?usp=sharing)**_

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

![An initial look at a simplified project architecture](https://i.imgur.com/L0dq7Ek.png)

This shows intial architecture plan was [sketched](https://i.imgur.com/vzR9JnO.png) during the first team standup. Note the colour assignment showing our extensions of the core brief.

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
+ Implemented an external RDS instance to act as a database for the deployment.
+ Credential issue with containerisation.
+ Automated Jenkins configuration and environmental variables.
+ Implemented in-pipeline docker build/push.
+ Amazon Fargate working through GUI.
+ CodePipeline working through GUI.

### End Point

![A picture of the endpoint of the Trello KanBan board, shortly before the presentation](https://i.imgur.com/pnMbvOd.png)

By the end of the project, all of our key deliverables, and most of our extensions had been completed. The fully serverless solution was operation, but not fully automated. This missed our high expectations but held true to two old adages which we will carry for the rest of our careers:

> _"Always under promise, and over deliver."_

Paired with:

> _"Never be satisfied."_

#### What Went Well

+ IaC enabled broad deployment with a region agnostic approach.
+ Pipeline functioned well in both an automated capacity and for multi-environment deployment.
+ Multifarious usage of Amazon curated services.
+ Multi-implementation of serverless solutions

#### What Could Be Improved

+ Little usage was found for configuration management in a project of this scale.
+ CloudTrail user tracking was not implemented for the project.
+ After deliberation, X-RAY was dropped from the project due to difficulties with the daemon.
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

|Risk No.|Risk Occured|Effects|Incidences (days across 1 week span)|Impact|Proposed Revision|
|---|---|---|---|---|---|
|1.0.1|Eyestrain.|Eyestrain from overexposure to computer displays.|7|2|Use f.lux on workstations, use night mode.|
|1.0.2|Backstrain.|Backstrain from remaining stationary for long period.|7|3|Get a better office chair.|
|1.0.3|Networking issues.|Conference calls interrupted, loss of internet.|4|3|Get an employer to pay for business class internet.|
|1.1.1|Instance container issues.|Containers caused instances to crash or reset.|3|4|Experiment with provider agnostic coding approach.|
|1.2.1|Kubernetes networking.|Container incompatability with Angular network processing.|2|3|Further research on java frontends and networking required.|
|1.3.1|Terraform destroy.|Terraform didn't reliably destroy resources.|3|4|Check using the GUI and manually delete.|
|1.4.1|Jenkins crashes.|Backend too large causes accidents.|3|3|Remember `maven clean install` to lessen build size.|
|1.5.1|AWS Permissions.|Unauthorised processes wouldn't run.|7|3|Careful research of required permissions.|
|1.6.1|Remote Exec.|Provisioner vs user sub-shell incompatability.|1|4|Wait for terraform code patches.|
|1.7.1|Fargate.|Did not work as advertised.|2|5|Wait for technology to be more mature, or extend project deadlines.|

There are three potential takeaways from the discrepancies between the first and second risk assessments:

1. Networking and permissions issues remain regardless of project length or size. Familiarity with cloud platforms and keeping up to date with the changing cloud landscape is required.

2. The impact of long working hours during the pandemic isolation can't be overstated. Teams must try hard to maintain work-life balance and maintain perspective.

3. Some things, you just can't forsee.

> _"“We demand rigidly defined areas of doubt and uncertainty!”_

―- Douglas Adams

To further illustrate the renewed risk assessment, a modified risk matrix is displayed below.

![A risk assessment matrix for the completion of the project.](https://i.imgur.com/xQM40mZ.png)

As can be seen from the matrix, skew was introduced to the usual risk set by the very short length of the project. Further discussion could be held as to which zoning should be applied to the red/yellow/green coded risks. An effort has been made to attempt to ensure a relatively neutral interpretation.

Of particular note in the diagram would be the two risks: backpain, and AWS permissions; both of which managed to cause significant impact to the team over the course of the project.

This leaves us with 2 core takeaways:

1. The importance of comfort for a long time working environment.

2. The importance of familiarity with providers in the current cloud marketplace.

> _“Perhaps home is not a place but simply an irrevocable condition.”_

―- James Baldwin

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
+ Database networking issues.
+ Remote Exec known errors.
+ Bash while loop scripting errors.
+ Terraform destroy incompleteness.
+ Fargate networking and structure lack of documentation.
+ X-ray complexity lack of time issues.

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

[This](https://ieeexplore.ieee.org/document/8959180) research meta-analysis offers a deeper look at the effectiveness of the toolsets available to support IaC driven development, and explores some of the ways in which this affects programming ethos.

#### Amran: NGINX Kubernetes

![Architecture showcase for the Kubernetes EKS interface](https://i.imgur.com/4ugbdkx.png)

As the code snippet below does not lend itself to a flow-diagram, the explanation above highlights the location of this process within our core architecture. Note the linkage to either Jenkins or CodePipeline.

```apiVersion: v1
kind: Service
metadata:
  name: nginx
spec:
  selector:
    app: nginx
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
  type: LoadBalancer
```
The above Kubernetes .YML file, alongside this: `aws eks update-kubeconfig --name <clusterName>` code snippet, allows the interface of the containers to the EKS node group, and provides the node balancing for the project. The presence of NGINX in this setting also ensures the provision of a website ARN (AWS provisioned DNS) if the node is connected to a public subnet within the VPN.

The kubeconfig command, entered through the Jenkins terminal during pipeline runs, provides IAM authentication to kubernetes in order to connect to the EKS cluster, as well as permissions to modify it. Without this snippet, the interface between the deployment pipeline and the cluster would fail, and the app would not be deployed.

For a look at advanced applications of Kubernetes, and an overview of its future goals, [this](https://www.theserverside.com/blog/Coffee-Talk-Java-News-Stories-and-Opinions/Kubernetes-118-adds-more-power-addresses-shortcomings) article may be of interest.

#### Thenuja: Lambda AMI Manager

![Lambda process flow](https://i.imgur.com/nb3OdCC.png)

The above diagram demonstrates the algorithmic process flow for the image creation lambda function. Related code block included below.

```def lambda_handler(event, context):
    ec2_res = boto3.resource('ec2')
    ec2_cli = boto3.client('ec2')
    amis = ec2_cli.describe_images(Owners=['self'])
    image_id = []
    for ami in amis['Images']:
        ami_id = ami['ImageId']
        print(ami['ImageId'])
        image_id.append(ami['ImageId'])
    if len(image_id) >= 1:
        print("deleting -> " + image_id[0])
        ec2.deregister_image(ImageId=image_id[0])
    snapshots = ec2_cli.describe_snapshots(OwnerIds=['self'])
    snap_id = []
    for snapshot in snapshots['Snapshots']:
        snap_id.append(snapshot.get('SnapshotId'))
    inst_id = []
    f1 = {'Name': 'tag:Name', 'Values':['jenkins-update']}
    resp = ec2_cli.describe_instances(Filters=[f1])
    for i in resp['Reservations']:
        for j in i['Instances']:
            inst_id.append(j['InstanceId'])
    response = ec2_cli.create_image(
        BlockDeviceMappings=[
            {
                'DeviceName': '/dev/sdh',
                'Ebs': {
                    'DeleteOnTermination': True,
                    'SnapshotId': snapshots[0],
                    'VolumeType': 'gp2',
                },
            },
        ],
        Description='jenkins',
        DryRun=False,
        InstanceId=inst_id[0],
        Name='Jenkins-Replacement',)
    return None
```

This code creates AMIs constructed from the most recent snapshot taken of the Jenkins instance and deletes any older ones.

The deletion subroutine runs first, deregistering any images. After this, an image is created; instance id and snapshot id are needed, line 15-16 obtains the snapshots and line 18-22 pulls the id of the instance called jenkins-update (the name of our Jenkins server).

A rate job calls snapshot creation via a lambda function once every six hours. Once this happens, a cloudwatch monitoring rule triggers the image creation function. The images built by this function are made available to the recovery function, which triggers in the event of Jenkins instance health loss.

Should this occur, the AMI will be used in the creation of an instance with identical attributes, enabling its smooth integration into surviving architecture.

[This](https://www.datadoghq.com/state-of-serverless/) article offers a look at the state of serverless solutions within the industry, and a discussion on issues related to this aspect of our project.

#### THC: Shell Script Automation

![Flow diagram to demonstrate interaction of shell automation](https://i.imgur.com/cENOLOh.png)

This linked timeline of part of the IaC build automation process, alongside the flow chart detailing the BASH scripts at play, visually demonstrates the following code snippets.

```echo 'jenkins ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers
i=1
until [ $i -eq 0 ];
do
    id -u jenkins >/dev/null 2>&1
    i=$(printf '%d\n' $?)
    sleep 5
done
touch /var/lib/jenkins/.bashrc
chmod 776 /var/lib/jenkins/.bashrc
```

The above code configures Jenkins pre-setup. Run by the root user on instance creation, this code adds Jenkins user to the sudoers group, waits until Jenkins boot sequence creates the Jenkins user, then adds a .bashrc file to its root filepath. This code is important in preventing hidden timeout and errors during the Jenkins server setup phase.

This code is run as part of a `user_data` block in terraform. This functionality allows predefined startup events to take place at the point of instance creation. As commands are executed by root, this block is ideal for running update, upgrade, and installation functionality. As seen from the `chmod` command, it is necessary to manage file ownership and permissions, to prevent errors during later usage.

Once this code has run, a secondary `remote-exec` null-resource runs. This resource is dependent on the creation of the RDS instance, and so waits during creation for variable availability before executing. After SSH-ing into the Jenkins instance, the following code block is run.

```while [ ! -f /var/lib/jenkins/.bashrc ]
do
    sleep 5
done
echo 'export url=${module.petclinic-db.rds-endpoint}' >> /var/lib/jenkins/.bashrc
echo 'export username=${var.db-username}' >> /var/lib/jenkins/.bashrc
echo 'export password=${var.db-password}' >> /var/lib/jenkins/.bashrc
sudo chown jenkins:jenkins /var/lib/jenkins/.bashrc
sudo chmod 444 /var/lib/jenkins/.bashrc
```

This code waits until the root user has finished creation of a .bashrc file at the jenkins user root. It then encodes our required environmental variables, drawing them from the terraform information provided; before changing file ownership to jenkins user, and modifying file permissions to read-only.

This dual process, executed at different points of the IaC runtime, exemplifies the flexibility of the toolset, and the importance of a multi-language approach on behalf of industry professionals. The usage of shellscript automation here ensures that the surrounding toolsets do not encounter errors during runtime, and allows near complete automation of the project functionality. Without this step multiple repository files would require editing by end-users.

[This article](https://link.springer.com/article/10.1007/s00450-019-00412-x) is a meta-analysis of DevOps automation practices that may be of interest to those considering a holistic approach to DevOps practices.

### UI

Potential logo

![NEW Logo](https://i.imgur.com/yipzmhX.gif)

A sort of project mascot, riffing on the theme of 'delivery pipeline'.

#### Potential Expansions

In the diagram below is an imagined architecture for an expansion of the serverless branch of our project.

![Expanded architecture diagram.](https://i.imgur.com/gVloD48.png)

+ Orange areas denote features that were unable to be included due to time constraints:
    - CodeCommit (pipeline link)
    - Amazon ECS Fargate connection
    - X Ray traffic tracing
+ Green areas denote features that could be included in a future expansion:
    - Athena for monitoring
    - Multi-Provider data storage
    - Monitoring with Kinesis
    - App extension interfacing with API Gateway
+ Knowledge in the languages in the top left would be required for this expansion.

## Testing

### Local Testing

The local testing runs eight url tests on the deployed container, utilising pytest.

### Final Report

![Coverage report for URL testing](https://i.imgur.com/rCsUH2P.jpg)

- The above coverage report details the completion of the URL testing conducted during standard pipeline runs.
- The presence of the application at the presumed url endpoint results in a 100% coverage.
- The url is automatically discovered via the command `curl https://ipinfo.io/ip`
- The unit testing specified on the spring-clinic README was unable to be implemented due to the angular version 8.0.3. The command `ng tes` results in an `version out of date` error message.
- Updated versions conflict with the core programming and result in similar errors.
- The current state of testing merely confirms the presence of a deployed container, there is scope for additional database, unit, and frontend testing.

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

Excepting the obvious slight scripting differences between Jenkins' GROOVY language and CodeBuild's .YAML files, the overall structure of the respective pipelines is very similar. Where Jenkins requires server tenancy, resources, and reasonable technical proficiency to setup; CodeBuild holds the edge in ease of use, plug-and-play adaptability, and in the streamlined nature of the pipeline and its provisioning. This comes at the cost of slight decrease in granularity of control, and in the binding of end users to Amazon's infrastructure.

Though serverless solutions can offer cost benefits in terms of OPEX, and cloud itself offers expenditure savings in terms of CAPEX, the current state of serverless solutions in requiring supporting products, means cloud engineers must be careful to avoid sunk cost expenditures. Particularly with the use of immature or fast released technologies, the personnel cost in terms of man-hours wasted to unsolved bugs should not be discounted.

Whilst CodeBuild itself was on the whole easy to use; its interface with CodePipeline, the necessity of output objects to s3 Buckets, and the difficulty of automating these resources through terraform, made its eventual implementation less easy than the proposal would have suggested.

Of particular note was the programmatic shift away from container creation and BASH scripting, toward a more in-depth use of `kubectl` commands, and a wide angle view of the Amazon CLI interface.

### Security

At the start of the project, all members of the team were provided with AWS credentials that would allow them access to specific resources within AWS. The credentials provided to each member allowed both Programmatic, and Management Console Access; however restrictions were in place to ensure that only the required resources needed for project completion were able to be accessed. This prevented misuse of AWS resources, and ensuring the security of the root account holder.

The procedure to do this involved attaching the specific required policies to a group that was created for the team. Users would then be created and placed within the group, so that the policies attached to the group would be automatically applied to the user created. Some of the policies attached included access to AWS resources such as; EKS for Kubernetes, EC2 instances to create the Jenkins and Worker Nodes, Lambda functions, in addition to some other minor policies.

When working with Terraform, a root key was used to run the terraform files as this ensured no conflicts when provisioning the infrastructure. However this meant that were Jenkins to be used to run the Kubernetes commands, the same credentials used to run the terraform files have to be reapplied. This is an issue that can be resolved, however due to time constraints, insufficient testing could be carried out to replace the root key.

Greater security measures relevant to the handling and distribution of keys and access management, potentially involving use of amazon security management resources, can be left to a future sprint.

Whilst testing the provisioning of infrastructure through Terraform, sensitive data would be hardcoded into the inputs.tf file, allowing the team to provision and test infrastructure quickly. Measures were in place to ensure that these details would be removed before committing changes to a VCS, particularly their removal after running a terraform apply/destroy command. 

To ensure sensitive infrastructure information was not exposed, a gitignore file was created, to ignore the contents of terraform dependency folders, .tfstate files, and other run time files.

### Branch and Merge Log

Log at time of README update: polled Dev branch at 22:42 05/05/2020

```* 2fda897 - Tue, 5 May 2020 17:45:25 +0100 (5 hours ago) (origin/serverless, serverless)
|           fargate retry - THC-QA
* 03d57e5 - Tue, 5 May 2020 16:15:59 +0000 (5 hours ago)
|           modules added - Ubuntu
| *   d130755 - Tue, 5 May 2020 17:16:58 +0100 (5 hours ago) (refs/stash)
| |\            WIP on serverless: 8f58927 codebuild - THC-QA
:...skipping...
* 2fda897 - Tue, 5 May 2020 17:45:25 +0100 (5 hours ago) (origin/serverless, serverless)
|           fargate retry - THC-QA
* 03d57e5 - Tue, 5 May 2020 16:15:59 +0000 (5 hours ago)
|           modules added - Ubuntu
| *   d130755 - Tue, 5 May 2020 17:16:58 +0100 (5 hours ago) (refs/stash)
| |\            WIP on serverless: 8f58927 codebuild - THC-QA
|/ /
| * 425c4c9 - Tue, 5 May 2020 17:16:58 +0100 (5 hours ago)
|/            index on serverless: 8f58927 codebuild - THC-QA
* 8f58927 - Tue, 5 May 2020 11:44:33 +0100 (11 hours ago)
|           codebuild - THC-QA
* 5d8a6e0 - Tue, 5 May 2020 10:01:24 +0000 (12 hours ago)
|           new fargate codebuild folders added - Ubuntu
* 8cc32ad - Tue, 5 May 2020 09:48:04 +0000 (12 hours ago)
|           Changes made from Dev Branch to setup for Serverless branch - Ubuntu
* 73ae74c - Tue, 5 May 2020 08:44:21 +0000 (13 hours ago)
|           add kube/build - Ubuntu
| * a9121b3 - Tue, 5 May 2020 12:03:54 +0100 (11 hours ago) (origin/terraform, terraform)
:...skipping...
* 2fda897 - Tue, 5 May 2020 17:45:25 +0100 (5 hours ago) (origin/serverless, serverless)
|           fargate retry - THC-QA
* 03d57e5 - Tue, 5 May 2020 16:15:59 +0000 (5 hours ago)
|           modules added - Ubuntu
| *   d130755 - Tue, 5 May 2020 17:16:58 +0100 (5 hours ago) (refs/stash)
| |\            WIP on serverless: 8f58927 codebuild - THC-QA
|/ /
| * 425c4c9 - Tue, 5 May 2020 17:16:58 +0100 (5 hours ago)
|/            index on serverless: 8f58927 codebuild - THC-QA
* 8f58927 - Tue, 5 May 2020 11:44:33 +0100 (11 hours ago)
|           codebuild - THC-QA
* 5d8a6e0 - Tue, 5 May 2020 10:01:24 +0000 (12 hours ago)
|           new fargate codebuild folders added - Ubuntu
* 8cc32ad - Tue, 5 May 2020 09:48:04 +0000 (12 hours ago)
|           Changes made from Dev Branch to setup for Serverless branch - Ubuntu
* 73ae74c - Tue, 5 May 2020 08:44:21 +0000 (13 hours ago)
|           add kube/build - Ubuntu
| * a9121b3 - Tue, 5 May 2020 12:03:54 +0100 (11 hours ago) (origin/terraform, terraform)
| |           updated rolling, started thc - THC-QA
| *   051781b - Tue, 5 May 2020 00:51:37 +0000 (21 hours ago)
| |\            Merge branch 'terraform' of https://github.com/THC-QA/qa_group_project into terraform - Ubuntu
| | * 4ff2c19 - Tue, 5 May 2020 01:44:13 +0100 (21 hours ago)
| | |           Thenu Article - THC-QA
| | * c7b484d - Tue, 5 May 2020 01:37:13 +0100 (21 hours ago)
| | |           Added testing report - THC-QA
| | * 2869667 - Tue, 5 May 2020 01:05:24 +0100 (22 hours ago)
| | |           Updated User Installation Guide - THC-QA
| * | ca1147f - Tue, 5 May 2020 00:50:27 +0000 (21 hours ago)
:...skipping...
* 2fda897 - Tue, 5 May 2020 17:45:25 +0100 (5 hours ago) (origin/serverless, serverless)
|           fargate retry - THC-QA
* 03d57e5 - Tue, 5 May 2020 16:15:59 +0000 (5 hours ago)
|           modules added - Ubuntu
| *   d130755 - Tue, 5 May 2020 17:16:58 +0100 (5 hours ago) (refs/stash)
| |\            WIP on serverless: 8f58927 codebuild - THC-QA
|/ /
| * 425c4c9 - Tue, 5 May 2020 17:16:58 +0100 (5 hours ago)
|/            index on serverless: 8f58927 codebuild - THC-QA
* 8f58927 - Tue, 5 May 2020 11:44:33 +0100 (11 hours ago)
|           codebuild - THC-QA
* 5d8a6e0 - Tue, 5 May 2020 10:01:24 +0000 (12 hours ago)
|           new fargate codebuild folders added - Ubuntu
* 8cc32ad - Tue, 5 May 2020 09:48:04 +0000 (12 hours ago)
|           Changes made from Dev Branch to setup for Serverless branch - Ubuntu
* 73ae74c - Tue, 5 May 2020 08:44:21 +0000 (13 hours ago)
|           add kube/build - Ubuntu
| * a9121b3 - Tue, 5 May 2020 12:03:54 +0100 (11 hours ago) (origin/terraform, terraform)
| |           updated rolling, started thc - THC-QA
| *   051781b - Tue, 5 May 2020 00:51:37 +0000 (21 hours ago)
| |\            Merge branch 'terraform' of https://github.com/THC-QA/qa_group_project into terraform - Ubuntu
| | * 4ff2c19 - Tue, 5 May 2020 01:44:13 +0100 (21 hours ago)
| | |           Thenu Article - THC-QA
| | * c7b484d - Tue, 5 May 2020 01:37:13 +0100 (21 hours ago)
| | |           Added testing report - THC-QA
| | * 2869667 - Tue, 5 May 2020 01:05:24 +0100 (22 hours ago)
| | |           Updated User Installation Guide - THC-QA
| * | ca1147f - Tue, 5 May 2020 00:50:27 +0000 (21 hours ago)
| |/            conditional statements added to jenkins installation, + minor code touchups - Ubuntu
:...skipping...
* 2fda897 - Tue, 5 May 2020 17:45:25 +0100 (5 hours ago) (origin/serverless, serverless)
|           fargate retry - THC-QA
* 03d57e5 - Tue, 5 May 2020 16:15:59 +0000 (5 hours ago)
|           modules added - Ubuntu
| *   d130755 - Tue, 5 May 2020 17:16:58 +0100 (5 hours ago) (refs/stash)
| |\            WIP on serverless: 8f58927 codebuild - THC-QA
|/ /
| * 425c4c9 - Tue, 5 May 2020 17:16:58 +0100 (5 hours ago)
|/            index on serverless: 8f58927 codebuild - THC-QA
* 8f58927 - Tue, 5 May 2020 11:44:33 +0100 (11 hours ago)
|           codebuild - THC-QA
* 5d8a6e0 - Tue, 5 May 2020 10:01:24 +0000 (12 hours ago)
|           new fargate codebuild folders added - Ubuntu
* 8cc32ad - Tue, 5 May 2020 09:48:04 +0000 (12 hours ago)
|           Changes made from Dev Branch to setup for Serverless branch - Ubuntu
* 73ae74c - Tue, 5 May 2020 08:44:21 +0000 (13 hours ago)
|           add kube/build - Ubuntu
| * a9121b3 - Tue, 5 May 2020 12:03:54 +0100 (11 hours ago) (origin/terraform, terraform)
| |           updated rolling, started thc - THC-QA
| *   051781b - Tue, 5 May 2020 00:51:37 +0000 (21 hours ago)
| |\            Merge branch 'terraform' of https://github.com/THC-QA/qa_group_project into terraform - Ubuntu
| | * 4ff2c19 - Tue, 5 May 2020 01:44:13 +0100 (21 hours ago)
| | |           Thenu Article - THC-QA
| | * c7b484d - Tue, 5 May 2020 01:37:13 +0100 (21 hours ago)
| | |           Added testing report - THC-QA
| | * 2869667 - Tue, 5 May 2020 01:05:24 +0100 (22 hours ago)
| | |           Updated User Installation Guide - THC-QA
| * | ca1147f - Tue, 5 May 2020 00:50:27 +0000 (21 hours ago)
| |/            conditional statements added to jenkins installation, + minor code touchups - Ubuntu
| | *   2b6d2e5 - Mon, 4 May 2020 23:32:54 +0100 (23 hours ago) (HEAD -> dev)
:...skipping...
* 2fda897 - Tue, 5 May 2020 17:45:25 +0100 (5 hours ago) (origin/serverless, serverless)
|           fargate retry - THC-QA
* 03d57e5 - Tue, 5 May 2020 16:15:59 +0000 (5 hours ago)
|           modules added - Ubuntu
| *   d130755 - Tue, 5 May 2020 17:16:58 +0100 (5 hours ago) (refs/stash)
| |\            WIP on serverless: 8f58927 codebuild - THC-QA
|/ /
| * 425c4c9 - Tue, 5 May 2020 17:16:58 +0100 (5 hours ago)
|/            index on serverless: 8f58927 codebuild - THC-QA
* 8f58927 - Tue, 5 May 2020 11:44:33 +0100 (11 hours ago)
|           codebuild - THC-QA
* 5d8a6e0 - Tue, 5 May 2020 10:01:24 +0000 (12 hours ago)
|           new fargate codebuild folders added - Ubuntu
* 8cc32ad - Tue, 5 May 2020 09:48:04 +0000 (12 hours ago)
|           Changes made from Dev Branch to setup for Serverless branch - Ubuntu
* 73ae74c - Tue, 5 May 2020 08:44:21 +0000 (13 hours ago)
|           add kube/build - Ubuntu
| * a9121b3 - Tue, 5 May 2020 12:03:54 +0100 (11 hours ago) (origin/terraform, terraform)
| |           updated rolling, started thc - THC-QA
| *   051781b - Tue, 5 May 2020 00:51:37 +0000 (21 hours ago)
| |\            Merge branch 'terraform' of https://github.com/THC-QA/qa_group_project into terraform - Ubuntu
| | * 4ff2c19 - Tue, 5 May 2020 01:44:13 +0100 (21 hours ago)
| | |           Thenu Article - THC-QA
| | * c7b484d - Tue, 5 May 2020 01:37:13 +0100 (21 hours ago)
| | |           Added testing report - THC-QA
| | * 2869667 - Tue, 5 May 2020 01:05:24 +0100 (22 hours ago)
| | |           Updated User Installation Guide - THC-QA
| * | ca1147f - Tue, 5 May 2020 00:50:27 +0000 (21 hours ago)
| |/            conditional statements added to jenkins installation, + minor code touchups - Ubuntu
| | *   2b6d2e5 - Mon, 4 May 2020 23:32:54 +0100 (23 hours ago) (HEAD -> dev)
| | |\            Merge branch 'terraform' into dev - THC-QA
| | |/
| |/|   
| * | af617a1 - Mon, 4 May 2020 23:31:01 +0100 (23 hours ago)
| | |           BASH until - THC-QA
| * | 4c35011 - Mon, 4 May 2020 22:38:55 +0100 (24 hours ago)
| | |           conflict - THC-QA
| * | 88919c4 - Mon, 4 May 2020 21:32:45 +0000 (24 hours ago)
| | |           bashrc permissions update - Ubuntu
| * | 12d46dd - Mon, 4 May 2020 21:31:35 +0000 (24 hours ago)
| | |           Working remote exec - Ubuntu
| * | 0d0e17d - Mon, 4 May 2020 21:27:23 +0000 (24 hours ago)
| | |           Working Remote Exec - Ubuntu
| | * 3819297 - Mon, 4 May 2020 22:24:04 +0000 (23 hours ago) (origin/dev)
| | |           cred not exposed in container - thenu97
| | * 17be1ec - Mon, 4 May 2020 22:17:42 +0000 (23 hours ago)
| | |           cred not exposed within container - thenu97
| | * 19387f7 - Mon, 4 May 2020 17:49:18 +0100 (29 hours ago)
| | |           rm -r - THC-QA
| | *   8c76ea3 - Mon, 4 May 2020 17:46:08 +0100 (29 hours ago)
| | |\            Merge branch 'jenkins' into dev - THC-QA
| | | * d036616 - Mon, 4 May 2020 14:44:03 +0000 (31 hours ago) (origin/jenkins, jenkins)
| | | |           backend image changed - thenu97
| | | * 186ea59 - Mon, 4 May 2020 14:34:50 +0000 (31 hours ago)
| | | |           script and dockerfile changed for external db - thenu97
| | | * bd94661 - Mon, 4 May 2020 14:33:14 +0000 (31 hours ago)
| | | |           backend sql inclusive - thenu97
| | | * d6295fb - Mon, 4 May 2020 12:22:45 +0000 (33 hours ago)
| | | |           env variables testing 1 - Ubuntu
| | | * 0c653ba - Mon, 4 May 2020 10:54:39 +0000 (35 hours ago)
| | | |           external database added - thenu97
| | | * 1af1276 - Sun, 3 May 2020 16:36:00 +0000 (2 days ago)
| | | |           kubectl changed - Ubuntu
| | | * 02148b9 - Sun, 3 May 2020 16:10:31 +0000 (2 days ago)
| | | |           testing finalised - Ubuntu
| | | * c8fd1bf - Sun, 3 May 2020 15:41:27 +0000 (2 days ago)
| | | |           changes to the url layout - Ubuntu
| | | * 3757442 - Sun, 3 May 2020 15:26:51 +0000 (2 days ago)
| | | |           testing changed - Ubuntu
| | | * 3d0541d - Sun, 3 May 2020 15:26:36 +0000 (2 days ago)
| | | |           fargate added - Ubuntu
| | * |   d92ac7e - Mon, 4 May 2020 17:45:31 +0100 (29 hours ago)
| | |\ \            Merge branch 'terraform' into dev - THC-QA
| | |/ /  
| |/| |   
| * | | 57dee5c - Mon, 4 May 2020 16:27:46 +0000 (29 hours ago)
| | | |           Functional Version - Ubuntu
| * | | 729acca - Mon, 4 May 2020 12:57:40 +0100 (34 hours ago)
| | | |           rds final test - THC-QA
| * | | af1548b - Mon, 4 May 2020 11:20:46 +0000 (34 hours ago)
| | | |           instructions for rds added - Ubuntu
| * | | b94f245 - Mon, 4 May 2020 02:59:41 +0100 (2 days ago)
| | | |           RDS rds RDS - THC-QA
| * | | 723bae7 - Sun, 3 May 2020 23:57:20 +0100 (2 days ago)
| | | |           Showcases Completed - THC-QA
| * | | a4f3ee9 - Sun, 3 May 2020 21:58:34 +0100 (2 days ago)
| | | |           Leon Showcase - THC-QA
| * | |   78e0494 - Sun, 3 May 2020 17:57:41 +0000 (2 days ago)
| |\ \ \            Merge branch 'terraform' of https://github.com/THC-QA/qa_group_project into terraform - Ubuntu
| | * | | 0ce52fb - Sun, 3 May 2020 18:49:02 +0100 (2 days ago)
| | | | |           Updated diagrams - THC-QA
| * | | | 5c361c6 - Sun, 3 May 2020 17:56:54 +0000 (2 days ago)
| |/ / /            changed instance-type to a global variable - Ubuntu
| * | | c704efd - Sun, 3 May 2020 15:50:34 +0000 (2 days ago)
| | | |           added tags to both subnets - Ubuntu
| * | |   3c6cf03 - Sun, 3 May 2020 15:47:53 +0100 (2 days ago)
| |\ \ \            Merge branch 'terraform' of https://github.com/THC-QA/qa_group_project into terraform - THC-QA
| | * | | ff5b279 - Sun, 3 May 2020 13:32:22 +0000 (2 days ago)
| | | | |           2nd dashboard title changed - Ubuntu
| * | | | 751120a - Sun, 3 May 2020 15:47:18 +0100 (2 days ago)
| |/ / /            sudoers - THC-QA
| | * |   56d11b0 - Sun, 3 May 2020 13:54:48 +0100 (2 days ago)
| | |\ \            Merge branch 'terraform' into dev to test branch assimilation - THC-QA
| | |/ /  
| |/| /   
| | |/    
| * | 5c76811 - Sun, 3 May 2020 13:28:23 +0100 (2 days ago)
| | |           spaces - THC-QA
| * | 9e929bc - Sun, 3 May 2020 13:23:30 +0100 (2 days ago)
| | |           lambda cleanup trigger - THC-QA
| * | 4ab7f0e - Sun, 3 May 2020 04:28:42 +0100 (3 days ago)
| | |           ToolChain - THC-QA
| * | 4d85599 - Sun, 3 May 2020 04:18:27 +0100 (3 days ago)
| | |           User Activity - THC-QA
| * | 3f4c88e - Sun, 3 May 2020 04:10:47 +0100 (3 days ago)
| | |           Update README.md Halfway - THC-QA
| * | 231f26e - Sun, 3 May 2020 00:46:00 +0100 (3 days ago)
| | |           lambda cleanup function - THC-QA
| * | c590f0f - Sat, 2 May 2020 18:53:29 +0000 (3 days ago)
| | |           Sns Topics added to trigger Jenkins-Recovery lambda function from cloudwatch metric alarm - Ubuntu
| * | 5b1c5d8 - Sat, 2 May 2020 17:29:55 +0100 (3 days ago)
| | |           reformat - THC-QA
| * | 075f197 - Sat, 2 May 2020 17:23:30 +0100 (3 days ago)
| | |           region - THC-QA
| * | 1d589a9 - Sat, 2 May 2020 17:02:34 +0100 (3 days ago)
| | |           tabbing - THC-QA
| * | 8ad4943 - Sat, 2 May 2020 16:57:33 +0100 (3 days ago)
| | |           json and eks_asg - THC-QA
| * | 8e65f23 - Sat, 2 May 2020 13:55:25 +0000 (3 days ago)
| | |           Commented out broken parts of code to be fixed - Ubuntu
| * | 2245a1e - Sat, 2 May 2020 10:29:16 +0000 (3 days ago)
| | |           t2.micro changed to t2.small, aws cli installation added to jenkinsscript - Ubuntu
| * | 28fac57 - Sat, 2 May 2020 00:35:02 +0100 (4 days ago)
| | |           dlm lifecycle - THC-QA
| * | 9db6a73 - Fri, 1 May 2020 23:38:04 +0100 (4 days ago)
| | |           lambda triplicate - THC-QA
| * | ef0c67f - Fri, 1 May 2020 19:58:31 +0000 (4 days ago)
| | |           lambda policies - Ubuntu
| * | ce84fe0 - Fri, 1 May 2020 16:56:32 +0100 (4 days ago)
| | |           lambda snapshot upload - THC-QA
| * | ef4d6f6 - Fri, 1 May 2020 15:16:50 +0100 (4 days ago)
| | |           lambda -payload - THC-QA
| * | d3b84ce - Fri, 1 May 2020 13:35:29 +0100 (4 days ago)
| | |           cloudwatch and lambda - THC-QA
| * |   cfcde7f - Thu, 30 Apr 2020 15:17:38 +0100 (5 days ago)
| |\ \            Merge pull request #4 from Leon-C-T/terraform - Leon-C-T
| | * | 3b198fe - Thu, 30 Apr 2020 14:14:16 +0000 (5 days ago)
| | | |           minor modification to name of security groups module - Ubuntu
| | * | ba02a6f - Thu, 30 Apr 2020 14:10:55 +0000 (5 days ago)
| |/ /            Added Jenkins install script to be executed by its associated ec2 instance - Ubuntu
| * |   30dd6a7 - Wed, 29 Apr 2020 18:38:32 +0100 (6 days ago)
| |\ \            Merge pull request #3 from Leon-C-T/terraform - Leon-C-T
| | * | 5140d2d - Wed, 29 Apr 2020 17:36:09 +0000 (6 days ago)
| | | |           Added Node Group to EKS - Ubuntu
| * | |   cc2fd5d - Wed, 29 Apr 2020 16:57:25 +0100 (6 days ago)
| |\ \ \            Merge pull request #2 from Leon-C-T/terraform - THC-QA
| | |/ /  
| | * | 4319c81 - Wed, 29 Apr 2020 15:55:16 +0000 (6 days ago)
| | | |           Initial Working Version of Terraform Architecture Files - Ubuntu
| | * | b13f681 - Wed, 29 Apr 2020 13:29:54 +0000 (6 days ago)
| | | |           added region to eks modules - Ubuntu
| * | |   fe4869c - Wed, 29 Apr 2020 13:08:28 +0100 (6 days ago)
| |\ \ \            Merge pull request #1 from Leon-C-T/terraform - THC-QA
| | |/ /  
| | * | 27bfe90 - Wed, 29 Apr 2020 12:01:01 +0000 (6 days ago)
| |/ /            Initial EKS module files created - Ubuntu
| * | 730445a - Wed, 29 Apr 2020 12:26:09 +0100 (6 days ago)
| | |           rearrange - THC-QA
| * | 973fd02 - Wed, 29 Apr 2020 11:48:27 +0100 (6 days ago)
| | |           env start - THC-QA
| * | 3f34c7b - Wed, 29 Apr 2020 11:24:16 +0100 (6 days ago)
| | |           subnet - THC-QA
| * | 105a430 - Wed, 29 Apr 2020 11:16:11 +0100 (6 days ago)
| | |           tweak var - THC-QA
| * | 739c062 - Wed, 29 Apr 2020 11:02:14 +0100 (7 days ago)
| | |           ec2 + vpc - THC-QA
| * | 238a18e - Wed, 29 Apr 2020 10:45:36 +0100 (7 days ago)
| | |           files - THC-QA
| * | a6d4296 - Wed, 29 Apr 2020 10:39:01 +0100 (7 days ago)
| | |           terraform - THC-QA
| | * 6b1857d - Sun, 3 May 2020 12:16:10 +0000 (2 days ago)
| | |           testing updated to dynamic ip - Ubuntu
| | * 1129dee - Sun, 3 May 2020 11:54:41 +0000 (2 days ago)
| | |           docker push automated - Ubuntu
| | * 330a2e4 - Sun, 3 May 2020 11:31:43 +0000 (2 days ago)
| | |           docker build/push automated - Ubuntu
| | * 8483296 - Sat, 2 May 2020 23:33:25 +0000 (3 days ago)
| | |           delete snapshot function added - Ubuntu
| | * 990b148 - Sat, 2 May 2020 18:04:51 +0000 (3 days ago)
| | |           ad kube stuff - Ubuntu
| | * 16617ff - Sat, 2 May 2020 09:29:30 +0000 (4 days ago)
| | |           delete added - Ubuntu
| | * 8b12fbf - Fri, 1 May 2020 22:27:18 +0000 (4 days ago)
| | |           lambdas done - Ubuntu
| | * 27fb899 - Fri, 1 May 2020 13:56:37 +0000 (4 days ago)
| | |           Jenkinsfile test 6 - Ubuntu
| | * d8fb41e - Fri, 1 May 2020 13:39:36 +0000 (4 days ago)
| | |           jenkinsfile test 5 - Ubuntu
| | * 4693777 - Fri, 1 May 2020 13:25:57 +0000 (4 days ago)
| | |           application ready - Ubuntu
| | * 7941275 - Fri, 1 May 2020 09:23:21 +0000 (5 days ago)
| | |           docker-compose updated - Ubuntu
| | * 6f65123 - Fri, 1 May 2020 09:14:42 +0000 (5 days ago)
| | |           docker-compose updated - Ubuntu
| | * 061e80c - Fri, 1 May 2020 09:12:41 +0000 (5 days ago)
| | |           before_in updated - Ubuntu
| | * 21597f0 - Thu, 30 Apr 2020 21:34:26 +0000 (5 days ago)
| | |           docker-compose file updated - thenu97
| | * dd5fda9 - Thu, 30 Apr 2020 21:33:31 +0000 (5 days ago)
| | |           extra task added - thenu97
| | * 9344bc7 - Thu, 30 Apr 2020 21:32:19 +0000 (5 days ago)
| | |           scripts added - thenu97
| | * 27f9cc0 - Thu, 30 Apr 2020 21:31:29 +0000 (5 days ago)
| | |           Jenkinsfile - thenu97
| | * cae2fe4 - Thu, 30 Apr 2020 10:12:06 +0000 (5 days ago)
| | |           install jenkins - Ubuntu
| | * fd1914c - Thu, 30 Apr 2020 10:51:47 +0100 (6 days ago)
| | |           ji - Amran-Lab
| | * b20823a - Wed, 29 Apr 2020 16:57:26 +0000 (6 days ago)
| |/            Jenkins installation - thenu97
| * f953525 - Wed, 29 Apr 2020 10:17:37 +0100 (7 days ago)
|/            txt - THC-QA
* c6391d1 - Wed, 29 Apr 2020 10:07:12 +0100 (7 days ago) (origin/master, origin/HEAD, master)
|           update readme - THC-QA
* c330eb3 - Mon, 27 Apr 2020 18:07:05 +0100 (8 days ago)
|           rm - THC-QA
* 6f5762d - Mon, 27 Apr 2020 18:05:39 +0100 (8 days ago)
|           initial structure - THC-QA
* 06d2ed4 - Mon, 27 Apr 2020 11:21:56 +0100 (8 days ago)
            Initial commit - THC-QA
```

The intended (now deprecated) structure of the project is below

```* MASTER
|
*
|\
| * Dev _______
|  \            \
|   * Jenkins    * Terraform
|
 \
  * Serverless
```

This structure allowed us to fold non-conflicting branches of the initial traditional server architecture project into dev, and keep master clean. The latter decision to pursue a serverless solution was branched off the near-empty master branch, as the structure was radically different to the dev branch.

These branches, and regular meetings to manage push/pull events, allowed the splitting of our four person unit into subteams who could engage daily tasks. An early split focussed on two core components of the traditional architecture; Jenkins, and Terraform.

Care must be taken whilst implementing git commands. Every time.

## Improvements for Future Versions

![SNS test](https://i.imgur.com/Jnxxmtu.png)

As can be seen from the above image, issues were encountered.

Due to time constraints on a single week project, some aspects of the serverless solution were beyond our ability to complete. They are listed here for inclusion in a future project expansion:

+ Expanded testing, particularly stress, unit, and database.
+ Complete automation of the serverless branch. Currently Fargate is created via CLI.
+ Correct networking of Fargate. Every attempt other than CLI commands appears to result in incomplete networking.
+ Use of multiple cloud providers for a provider agnostic solution.
+ Implementing SNS for the autoscaling group as well as the CodeBuild results.
+ Enhanced monitoring of the project, this can come in several stages:
    - CloudTrail
    - X Ray
    - Kinesis
    - Athena
+ Enhanced security features for the project, this could include:
    - Cognito
    - Inspector
    - Guard Duty
    - Secrets Manager

To accompany some of these expansions, an imagined future Sprint has been outlined on the Kanban below. This sprint would take approximately a month, and could be subdivided into feature focuses.

![An imagined kanban board for the database sprint of an updated project](https://i.imgur.com/I59IeCB.png)

To pair with this imagined sprint, a potential risk assessment has been provided, in simplified form, below:

|Risk Code|Potential Risk|Potential Impact|Hypothetical Preventative Measure|
|---|---|---|---|
|1.0.1|Budget constraints.|5|Acquire funding.|
|1.1.1|Java expertise.|4|Acquire training.|
|1.2.1|AWS familiarity.|3|Spend time.|
|1.2.2|AWS networking.|3|Diversify team skills portfolio.|
1.2.3|Multi Provider conflicts.|4|Research.|

Currently, enthusiastically, most of our imagined risks require time and learning to solve.

## Installation and Setup Guide

1. Clone down this repository.
2. Create or login to your AWS account.
3. Generate an AWS .pem key, downloading your copy and noting the name. Note: YOUR KEY MUST BE CREATED IN THE REGION YOU INTEND TO DEPLOY TO.
4. Navigate to the eu-west-2 folder of this directory, and place your copy of the AWS key here.
5. Install terraform following [this guide](https://learn.hashicorp.com/terraform/getting-started/install.html).
6. In the folder, run the command `terraform init` followed by `terraform plan`.
7. Provide the variables as requested by terraform, and check that no errors are thrown.
![This is what no errors looks like](LINKPENDING
8. Still in the folder, run the command `terraform apply`.
![This is what a successful application looks like](
9. Copy the endpoint for later application.
10. Navigate to your AWS web console and follow the instructions to ssh to your newly created EC2 instance. This can be found by searching EC2 in the upper right search bar.
11. On the EC2 server, run the command `sudo su jenkins`.
    1. Run the command `aws configure` inserting the credentials you used for terraform.
    2. cd to the root directory of jenkins and add the following lines to the .bashrc file; remembering to enter your docker user data if you have some, and creating some if you don't:
        + export DOCKER_USER= `YOUR-USERNAME`
        + export DOCKER_PASS= `YOUR-PASSWORD`
12. Get the IP address of the server you're on.
13. Open a web browser and paste it in the address bar using the format `ipaddress:8080`.
    1. `cat` initial password as directed on the Jenkins welcome page
    2. Install plugins and sign up to Jenkins as directed.
14. ~~Follow the link [here](https://github.com/THC-QA/qa_group_project/tree/dev/spring-petclinic-res/src/main/resources/db/mysql) and ensure you copy and paste the .sql files to the created database. Use the endpoint provided to ssh to the resource.~~ [This step now automated]
15. Using the guide found [here](https://embeddedartistry.com/blog/2017/12/21/jenkins-kick-off-a-ci-build-with-github-push-notifications/) configure your copy of the repository to allow webhooks.
16. Completing the procedure, use the guide found [here](https://dzone.com/articles/adding-a-github-webhook-in-your-jenkins-pipeline) to add the webhook to your Jenkins server.
15. Run the Jenkins pipeline.
    1. The first run of the pipeline is designed to fail as Jenkins user will be added to the Docker group. This requries a system reboot.
16. Reboot the jenkins server using the AWS web interface.
    1. Wait until the system has rebooted, then wait an additional minute for Jenkins to reactivate.
    2. Login to your jenkins again, following the earlier steps.
    3. Press build.
17. The application will now be running on the EKS cluster defined in the terraform plan.

#### Authors

THC, thenu97, Amran-Lab, Leon-C-T - QA Academy Trainees.

#### Acknowledgements

A massive thank you to Syed, for fielding our endless questions, and many thanks to QA-Limited for the opportunity, training, and our operational budget.

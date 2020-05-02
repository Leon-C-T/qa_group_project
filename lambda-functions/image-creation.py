import boto3



def lambda_handler(event, context):
    ec2_res = boto3.resource('ec2')
    ec2_cli = boto3.client('ec2')

    #get images that are owned by oneself
    amis = ec2_cli.describe_images(Owners=['self'])
    image_id = []
    for ami in amis['Images']:
        ami_id = ami['ImageId']
        print(ami['ImageId'])
        image_id.append(ami['ImageId'])

    #if image already exits then delete it because we can't have images with the same name
    #so if this is automated, they'll end up having the same name, which will throw an error
    if len(image_id) >= 1:
        print("deleting -> " + image_id[0])
        # deregister the AMI
        ec2.deregister_image(ImageId=image_id[0])

    #describe_snapshots is a boto3 command, filtering it with self 
    #getting all the snapshots that are owned by oneself
    snapshots = ec2_cli.describe_snapshots(OwnerIds=['self'])
    snap_id = []
    for snapshot in snapshots['Snapshots']:
        snap_id.append(snapshot.get('SnapshotId'))

    print(snap_id)

    #filtering instances based on the name given at creation 
    inst_id = []
    f1 = {'Name': 'tag:Name', 'Values':['jenkins-update']}
    resp = ec2_cli.describe_instances(Filters=[f1])
    for i in resp['Reservations']:
        for j in i['Instances']:
            inst_id.append(j['InstanceId'])
    print(inst_id)

    #creating an image 
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
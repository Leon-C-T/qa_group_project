import boto3
def lambda_handler(event, context):
    ec2_res = boto3.resource('ec2')
    ec2_cli = boto3.client('ec2')
    resp = ec2_cli.describe_instances()
    resp_describe_snapshots = ec2_cli.describe_snapshots(OwnerIds=['self'])
    snapshot = resp_describe_snapshots['Snapshots']
    snapshots = []
    for snapshotIdList in resp_describe_snapshots['Snapshots']:
        snapshots.append(snapshotIdList.get('SnapshotId'))

    print(snapshots)


    inst_id = []
    f1 = {'Name': 'tag:Name', 'Values':['jenkins-update']}
    resp = ec2_cli.describe_instances(Filters=[f1])
    for i in resp['Reservations']:
        for j in i['Instances']:
            inst_id.append(j['InstanceId'])
    print(inst_id)

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
        Name='Jenkins-Replacement0',)

    return None
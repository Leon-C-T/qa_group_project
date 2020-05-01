import boto3

def lambda_handler(event, context):
    ec2_cli = boto3.client('ec2')
    ec2_res = boto3.resource('ec2')
    image_ids = []
    response = ec2_cli.describe_images(Owners=['self'])
    for i in response['Images']:
        print(i['ImageId'])
        image_ids.append(i['ImageId'])                                                                                           
    
    instance = ec2_res.create_instances(
        ImageId=image_ids[0],
        InstanceType='t2.small',
        KeyName='qapetclinic',
        MaxCount=1,
        MinCount=1)
    
    return None
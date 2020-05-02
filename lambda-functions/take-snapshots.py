import boto3                                                


def lambda_handler(event, context):
   inst_id = []
   ec2_re = boto3.resource('ec2')
   ec2_cli = boto3.client('ec2')

   #filtering out instanceIds based on the name 'jenkins-update because that's the instance we want to take a snapshot of'
   #jenkins-update was a name given to the jenkins server on creation through terraform
   f1 = {'Name': 'tag:Name', 'Values':['jenkins-update']}
   #since low level access client objects are used, the output is a dict so it's hard to manipulate than resource objects
   resp = ec2_cli.describe_instances(Filters=[f1])
   for i in resp['Reservations']:
      for j in i['Instances']:
         inst_id.append(j['InstanceId'])


   vol_id = []
   #getting all the volumeIds based on the instance that we've just filtered out
   #the output for resource objects are objects in itself so it doesn't require much manipulation
   instance = ec2_re.Instance(inst_id[0])
   #block_device_mappings has an 'Ebs' attribute, where you can find VolumeId
   for device in instance.block_device_mappings:
      volume = device.get('Ebs')
      vol_id.append(volume.get('VolumeId'))

   #taking snapshots of all the volumes we got in the previous step
   snap_ids=[]
   for i in vol_id:
      response= ec2_re.create_snapshot(                                                                                      
         Description='Snap with Lambda',                                                                                       
         VolumeId=i,                                                                                                  
         TagSpecifications=[                                                                                                   
               {                                                                                                
                  'ResourceType': 'snapshot',                                                                                   
                  'Tags': [                                                                                                    
                     {                                                                                                         
                        'Key': 'Delete-on',                                                                                   
                        'Value':'90'                                                                                          
                     }                                                                                                        
                  ]                                                                                                   
               }                                                                                                               
            ]                                                                                                                  
         )                                                                                                                    
      snap_ids.append(response.id)
   return None
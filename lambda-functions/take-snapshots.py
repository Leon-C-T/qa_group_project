import boto3                                                


def lambda_handler(event, context):
   inst_id = []
   ec2_re = boto3.resource('ec2')
   ec2_cli = boto3.client('ec2')
   f1 = {'Name': 'tag:Name', 'Values':['jenkins-update']}
   resp = ec2_cli.describe_instances(Filters=[f1])
   for i in resp['Reservations']:
      for j in i['Instances']:
         inst_id.append(j['InstanceId'])


   vol_id = []
   instance = ec2_re.Instance(inst_id[0])
   for device in instance.block_device_mappings:
      volume = device.get('Ebs')
      vol_id.append(volume.get('VolumeId'))


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

                                                                                                               
   print(snap_ids)                                                                                                      
   waiter = ec2_cli.get_waiter('snapshot_completed')
   waiter.wait(SnapshotIds=snap_ids)
   return None
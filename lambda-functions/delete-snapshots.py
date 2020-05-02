import boto3
import datetime
from datetime import date

def lambda_handler(event, context):
    client = boto3.client(service_name="ec2")
    exist = None
    while True:
        if exist:
            response = client.describe_snapshots(NextToken = exist)
        else:
            response = client.describe_snapshots(OwnerIds=['self'])
        snapshots = response['Snapshots']
        for snap in snapshots:
            snap_ids = snap['SnapshotId']
            snap_date = datetime.datetime.strftime(snap['StartTime'], '%d')
            date_today = datetime.datetime.strftime(date.today(), '%d')
            diff = int(snap_date) - int(date_today)
            if diff == 0:
                client.delete_snapshot(SnapshotId=snap_ids)
        try:
            exist = response['NextToken']
        except KeyError:
            break
    return None
import boto3
from datetime import datetime, timedelta


def lambda_handler(event, context):
    client = boto3.client('dynamodb')

    # stamp = datetime.strptime(event['timestamp'], '%d-%m-%Y %H:%M:%S')
    # rounded_timestamp = stamp.replace(minute=0, second=0)
    # final = rounded_timestamp.strftime('%d-%m-%Y %H:%M:%S')
    # print(final)
    # print(event['timestamp'])
    # print(final == event['timestamp'])

    response = client.put_item(
        TableName='WeatherTable',
        Item={
            'temperature': {'N': str(event['temperature'])},
            'humidity': {'N': str(event['humidity'])},
            'timestamp': {'S': event['timestamp']},
            'id': {'S': event['id']}
        }
    )

    return 0

# { "temperature" : { "N" : "29.3" }, "humidity" : { "N" : "64" }, "timestamp" : { "S" : "08-11-2024 16:47:23" } }

import boto3
import os
import json
from boto3.dynamodb.conditions import Attr
from decimal import Decimal

# Initialize DynamoDB client
dynamodb = boto3.resource('dynamodb')
table_name = 'WeatherTable'

# Helper function to convert Decimal to standard Python types


def decimal_to_float(obj):
    if isinstance(obj, list):
        return [decimal_to_float(x) for x in obj]
    elif isinstance(obj, dict):
        return {k: decimal_to_float(v) for k, v in obj.items()}
    elif isinstance(obj, Decimal):
        return float(obj)  # Convert Decimal to float
    else:
        return obj


def lambda_handler(event, context):
    table = dynamodb.Table(table_name)

    filter_date = event.get('queryStringParameters', {}).get(
        'date', None)  # e.g., '2024-12-08'
    filter_id = event.get('queryStringParameters', {}).get(
        'id', None)      # e.g., 'inside'

    try:
        filter_expression = None

        # If date is provided, convert to timestamp range
        if filter_date:
            start_timestamp = f"{filter_date} 00:00:00"
            end_timestamp = f"{filter_date} 23:59:59"
            filter_expression = Attr('timestamp').between(
                start_timestamp, end_timestamp)

        # If id is provided, add it to the filter
        if filter_id:
            if filter_expression:
                filter_expression &= Attr('id').eq(filter_id)
            else:
                filter_expression = Attr('id').eq(filter_id)

        # Scan with filter expression if any filter is provided
        if filter_expression:
            response = table.scan(FilterExpression=filter_expression)
        else:
            # Retrieve all data if no filters are provided
            response = table.scan()

        items = response.get('Items', [])

        # Convert Decimal values to standard types
        items = decimal_to_float(items)

        return {
            'statusCode': 200,
            'body': json.dumps(items)
        }
    except Exception as e:
        print(f"Error fetching data from DynamoDB: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps({"error": str(e)})
        }

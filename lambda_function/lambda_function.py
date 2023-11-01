import json
import boto3
from botocore.exceptions import ClientError
from decimal import Decimal

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('JediTable')

def lambda_handler(event, context):
    http_method = event.get('httpMethod')
    
    if http_method == 'GET':
        query_params = event.get('queryStringParameters') or {}
        jedi_id = query_params.get('jedi_id')
        if jedi_id:
            return handle_get(jedi_id)
        else:
            return handle_get_all()
    elif http_method == 'POST':
        return handle_post(event)
    else:
        return {'statusCode': 405, 'body': json.dumps('Method Not Allowed')}


def handle_get(jedi_id):
    try:
        response = table.get_item(Key={'id': jedi_id})
    except ClientError as e:
        print(e.response['Error']['Message'])
        return {'statusCode': 500, 'body': json.dumps('Internal Server Error')}
    else:
        item = response.get('Item')
        if not item:
            return {'statusCode': 404, 'body': json.dumps('Jedi not found')}
        item = convert_decimals(item)
        return {'statusCode': 200, 'body': json.dumps(item)}


def handle_post(event):
    try:
        body = json.loads(event.get('body', '{}'), parse_float=Decimal)
    except json.JSONDecodeError:
        return {'statusCode': 400, 'body': json.dumps('Invalid JSON')}

    if not isinstance(body, list):
        body = [body]

    for jedi in body:
        jedi_id = jedi.get('id')
        if not jedi_id:
            return {'statusCode': 400, 'body': json.dumps('Missing Jedi ID')}

        # Check if the Jedi ID already exists
        existing_item = table.get_item(Key={'id': jedi_id}).get('Item')
        if existing_item:
            return {'statusCode': 409, 'body': json.dumps(f'Jedi ID {jedi_id} already exists')}

        # Insert the new Jedi into the DynamoDB table
        table.put_item(Item=jedi)

    return {'statusCode': 201, 'body': json.dumps('Jedi added successfully')}

def handle_get_all():
    try:
        response = table.scan()
    except ClientError as e:
        print(e.response['Error']['Message'])
        return {'statusCode': 500, 'body': json.dumps('Internal Server Error')}
    else:
        items = response.get('Items', [])
        if not items:
            return {'statusCode': 404, 'body': json.dumps('No Jedi found')}
        converted_items = [convert_decimals(item) for item in items]
        return {'statusCode': 200, 'body': json.dumps(converted_items)}


def convert_decimals(obj):
    if isinstance(obj, list):
        return [convert_decimals(i) for i in obj]
    elif isinstance(obj, dict):
        return {k: convert_decimals(v) for k, v in obj.items()}
    elif isinstance(obj, Decimal):
        if obj % 1 > 0:
            return float(obj)
        else:
            return int(obj)
    else:
        return obj

import os
import boto3
import requests
from dotenv import load_dotenv
from pathlib import Path
from bs4 import BeautifulSoup

def load_secrets():
    url_secret = os.getenv('SCRAPE_URL')
    return url_secret

def url_parser(url):
    res = requests.get(url) 
    soup = BeautifulSoup(res.content, 'html.parser')

    if soup:
        return soup
    else:
        return 'Parsing failed'

def get_car_models(parsed_url):
    content = parsed_url.find_all('div', id='model-list')
    
    if content:
        return content
    else:
        return 'Models not found'

def get_car_model_details(car_models):
    if car_models:
        for model in car_models:
            car_details = model.find_all('div', class_='content')
    
            if car_details:
                return car_details
            else:
                return 'Car details not found'

def get_car_model_name(car_detail):
    if car_detail:
        car_model_name = car_detail.find('h2')
        if car_model_name:
            return car_model_name.text

    return None

def get_car_model_price(car_detail):
    if car_detail:
        car_model_price = car_detail.find('strong')
        if car_model_price:
            return car_model_price.text

    return None

def combine_car_details(car_details):
    result = []

    if car_details:
        for detail in car_details:
            car_model_name = get_car_model_name(detail)
            car_model_price = get_car_model_price(detail)
                    
            if car_model_name and car_model_price:
                car_data = {
                    'model_name': car_model_name.strip(),
                    'model_price': int(car_model_price.replace(' ', '').strip())
                    }
            else:
                car_data = None
                return 'Car model or price not found'

            if car_data not in result:
                result.append(car_data)

    return result

def save_to_dynamodb(car_data):
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('car_table')

    if table is None:
        return 'Table not found'
    
    with table.batch_writer() as batch:
        for item in car_data:
            batch.put_item(Item=item)

def handler(event, context):
    scrape_url = load_environment_variables()
    if not scrape_url:
        return {
            'statusCode': 500,
            'body': 'SCRAPE_URL environment variable not set'
        }

    parsed_url = url_parser(scrape_url)
    car_models = get_car_models(parsed_url)
    car_details = get_car_model_details(car_models)
    content = combine_car_details(car_details)
    
    if content:
        save_to_dynamodb(content)
        return {
            'statusCode': 200,
            'body': 'Data successfully saved to DynamoDB'
        }
    else:
        return {
            'statusCode': 500,
            'body': 'No data to save'
        }

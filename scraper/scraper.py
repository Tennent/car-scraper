import os
import requests
from dotenv import load_dotenv
from pathlib import Path
from bs4 import BeautifulSoup

def load_environment_variables():
    load_dotenv()
    return os.getenv('SCRAPE_URL')

def url_parser(url):
    res = requests.get(url) 
    soup = BeautifulSoup(res.content, 'html.parser')
    return soup

def get_car_models(url):
    parsed_url = url_parser(url)
    content = parsed_url.find_all('div', id='model-list')
    return content

def get_car_model_details(url):
    car_models = get_car_models(url)

    if car_models:
        for model in car_models:
            car_details = model.find_all('div', class_='content')
    
    return car_details

def scrape_content(url):
    car_details = get_car_model_details(url)
    result = []

    if car_details:
        for detail in car_details:
            car_model_name = detail.find('h2')
            car_model_price = detail.find('strong')
                    
            if car_model_name and car_model_price:
                car_data = {
                    'model': car_model_name.get_text(strip=True),
                    'price': car_model_price.get_text(strip=True)
                    }
                if car_data not in result:
                    result.append(car_data)

    return result

def handler(event, context):
    scrape_url = load_environment_variables()
    if not scrape_url:
        return {
            'statusCode': 500,
            'body': 'SCRAPE_URL environment variable not set'
        }

    content = scrape_content(scrape_url)
    
    return {
        'statusCode': 200,
        'body': content
    }

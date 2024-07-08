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

def get_car_models(parsed_url):
    content = parsed_url.find_all('div', id='model-list')
    return content

def get_car_model_details(car_models):
    if car_models:
        for model in car_models:
            car_details = model.find_all('div', class_='content')
    
    return car_details

def get_car_model_name(car_details):
    if car_details:
        for detail in car_details:
            car_model_name = detail.find('h2')
    
    return car_model_name

def get_car_model_price(car_details):
    if car_details:
        for detail in car_details:
            car_model_price = detail.find('strong')
    
    return car_model_price

def handler(event, context):
    scrape_url = load_environment_variables()
    if not scrape_url:
        return {
            'statusCode': 500,
            'body': 'SCRAPE_URL environment variable not set'
        }

    content = combine_car_details(scrape_url)
    
    return {
        'statusCode': 200,
        'body': content
    }

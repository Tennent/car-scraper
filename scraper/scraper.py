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

def scrape_content(url):
    parsed_url = url_parser(url)
    content = parsed_url.find_all('div', id='model-list')
    
    result = []

    if content:
        for item in content:
            car_info_list = item.find_all('div', class_='content')

            if car_info_list:
                for car_info in car_info_list:
                    car_model_name = car_info.find('h2')
                    car_model_price = car_info.find('strong')
                    
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

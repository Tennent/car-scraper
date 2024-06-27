import os
import requests
from dotenv import load_dotenv
from pathlib import Path
from bs4 import BeautifulSoup

def load_environment_variables():
    load_dotenv()
    return os.getenv('SCRAPE_URL')

def scrape_content(url):
    res = requests.get(url)
    soup = BeautifulSoup(res.content, 'html.parser')
    content = soup.find_all('div', class_='item-outer-container')
    content_list = [str(item) for item in content]
    return content_list

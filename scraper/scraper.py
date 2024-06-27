import os
import requests
from dotenv import load_dotenv
from pathlib import Path
from bs4 import BeautifulSoup

def load_environment_variables():
    load_dotenv()
    return os.getenv('SCRAPE_URL')

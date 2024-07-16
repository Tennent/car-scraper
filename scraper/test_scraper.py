import pytest
from bs4 import BeautifulSoup
from scraper import (
    get_car_models,
)

def test_get_car_models():
    html = '<html><body><div id="model-list"><div class="content"></div></div></body></html>'
    soup = BeautifulSoup(html, 'html.parser')
    result = get_car_models(soup)
    assert len(result) == 1
    assert result[0].find('div', class_='content') is not None

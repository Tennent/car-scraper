import pytest
from bs4 import BeautifulSoup
from scraper import (
    load_environment_variables,
    get_car_models,
    get_car_model_details,
    get_car_model_name,
    get_car_model_price,
    combine_car_details
)

def test_load_environment_variables(monkeypatch):
    monkeypatch.setenv('SCRAPE_URL', 'http://example.com')
    assert load_environment_variables() == 'http://example.com'

def test_get_car_models():
    html = '<html><body><div id="model-list"><div class="content"></div></div></body></html>'
    soup = BeautifulSoup(html, 'html.parser')
    result = get_car_models(soup)
    assert len(result) == 1
    assert result[0].find('div', class_='content') is not None

def test_get_car_model_details():
    html = '<div id="model-list"><div class="content"></div></div>'
    soup = BeautifulSoup(html, 'html.parser')
    car_models = soup.find_all('div', id='model-list')
    result = get_car_model_details(car_models)
    assert len(result) == 1
    assert result[0].get('class') == ['content']

def test_get_car_model_name():
    html = '<div class="content"><h2>Model Name</h2></div>'
    soup = BeautifulSoup(html, 'html.parser')
    car_detail = soup.find('div', class_='content')
    result = get_car_model_name(car_detail)
    assert result == 'Model Name'

def test_get_car_model_price():
    html = '<div class="content"><div><strong>5000000 HUF</strong></div></div>'
    soup = BeautifulSoup(html, 'html.parser')
    car_detail = soup.find('div', class_='content')
    result = get_car_model_price(car_detail)
    assert result == '5000000 HUF'

def test_combine_car_details():
    html = '''
    <div class="content">
        <h2>Model A</h2>
        <div>
            <strong>5000000</strong>
        </div>
    </div>
    <div class="content">
        <h2>Model B</h2>
        <div>
            <strong>6000000</strong>
        </div>
    </div>
    '''
    soup = BeautifulSoup(html, 'html.parser')
    car_details = soup.find_all('div', class_='content')
    result = combine_car_details(car_details)
    assert result == [
        {'model': 'Model A', 'price': '5000000 HUF'},
        {'model': 'Model B', 'price': '6000000 HUF'}
    ]

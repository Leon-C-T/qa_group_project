import pytest
import requests
import os

url = os.environ['url']

############################################################### testing url ###############################################################
def test_urlmanager_home():
    r = requests.get(url)
    assert r.status_code == 200
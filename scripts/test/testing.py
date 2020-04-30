import pytest
import requests

url = "http://35.197.229.247/"

############################################################### testing url ###############################################################
def test_urlmanager_home():
    r = requests.get(url)
    assert r.status_code == 200
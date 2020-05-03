import pytest
import requests
import os

urt = os.environ['url']

############################################################### testing url ###############################################################
def test_urlmanager_home():
    url = 'http://' + urt
    r = requests.get(url)
    assert r.status_code == 200
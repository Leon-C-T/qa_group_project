import pytest
import requests

url = "ec2-35-177-109-163.eu-west-2.compute.amazonaws.com/"

############################################################### testing url ###############################################################
def test_urlmanager_home():
    r = requests.get(url)
    assert r.status_code == 200
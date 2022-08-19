from fastapi.testclient import TestClient
from requests import Response

from main import app

client: TestClient = TestClient(app)


def test_index() -> None:
    """
    Test GET method
    """
    response: Response = client.get("/")
    assert response.status_code == 200
    assert response.json()["message"] == 'Hello World'


def test_hello() -> None:
    """
    Test GET method
    """
    name: str = "User"
    response: Response = client.get(f"/hello/{name}")
    assert response.status_code == 200
    assert response.json()["message"] == f'Hello, {name}'

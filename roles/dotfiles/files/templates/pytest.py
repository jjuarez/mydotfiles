"""${MODULE} unit tests"""
import pytest
from ${PACKAGE}.${MODULE} import ...



@pytest.fixture(scope="class")
def fixture_name() -> dict:
    """
    This will be the documenatation for your fixture

    Returns:
        dict: Remember to change this to the right type
    """
    return {"name": "Test", "region": "us-south", "resource_group": "Test Resource Group"}


class TestCase:
    """
    This is the documentation for all the Test Case
    """
    def test_properties(self, fixture_name: dict) -> None:
        """
        This is the documentation for the test

        Arguments:
            fixture_name (dict): Say something about this argument
        """
        assert True

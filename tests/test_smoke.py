import python_template


def test_package_imports_and_has_version():
    assert python_template.__version__ == "0.1.0"


def test_greet_with_valid_name():
    assert python_template.greet("World") == "Hello, World!"

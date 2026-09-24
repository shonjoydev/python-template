import my_project


def test_package_imports_and_has_version():
    assert my_project.__version__ == "0.1.0"


def test_greet_with_valid_name():
    assert my_project.greet("World") == "Hello, World!"

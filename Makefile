.PHONY: help install sync test test-cov watch lint format format-check type-check security pre-commit clean run all ci

help:  ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

install:  ## Install dependencies with dev extras (creates .venv automatically)
	uv sync --extra dev

sync:  ## Sync dependencies to match the lockfile
	uv sync

test:  ## Run tests
	uv run pytest

test-cov:  ## Run tests with an HTML + terminal coverage report
	uv run pytest --cov --cov-report=html --cov-report=term-missing

watch:  ## Re-run tests automatically on every save (TDD loop)
	uv run ptw .

lint:  ## Run the linter
	uv run ruff check .

format:  ## Auto-format code
	uv run ruff format .

format-check:  ## Check formatting without changing files
	uv run ruff format --check .

type-check:  ## Run the type checker
	uv run mypy src/

security:  ## Scan source code for common security issues
	uv run bandit -r src/

pre-commit:  ## Run all pre-commit hooks against every file
	uv run pre-commit run --all-files

run:  ## Run the main application
	uv run python -m my_project.main

clean:  ## Remove build artifacts and caches
	rm -rf build dist *.egg-info htmlcov .pytest_cache .coverage .mypy_cache .ruff_cache
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete

all: format lint type-check security test  ## Run all checks and auto-fix what can be fixed

ci: format-check lint type-check security test  ## Run CI checks (no auto-fix)

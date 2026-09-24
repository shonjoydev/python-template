# python-template

A modern Python starter project managed with [uv](https://github.com/astral-sh/uv), set up for test-driven development with pytest, and linted/formatted/type-checked with ruff and mypy.

## Prerequisites

- Python 3.9+ (uv will install the pinned version for you if it's missing — see `.python-version`)
- [uv](https://docs.astral.sh/uv/):

  ```bash
  curl -LsSf https://astral.sh/uv/install.sh | sh
  ```

  (Windows: `powershell -c "irm https://astral.sh/uv/install.ps1 | iex"`)

No manual `venv` creation or activation needed — uv manages an isolated `.venv` for you automatically whenever you run `uv sync` or `uv run`.

> New to the project, on Windows, or something not working? **SETUP.md** has the full walkthrough — one-command and manual paths, activation instructions, and a troubleshooting table.

## Using this as a GitHub template

This repo is set up to rename itself automatically. Once you (the template owner) do the one-time setup below, anyone who clicks **"Use this template"** gets a repo that already matches their project's name — no manual find-and-replace.

**One-time, as the template owner:**

1. Push this repo to GitHub.
2. Go to **Settings → General**, tick **Template repository**.

**Every time someone generates a repo from it:**

1. They click **"Use this template" → "Create a new repository"** and name it, e.g. `todo-tracker`.
2. GitHub creates `todo-tracker` from this repo's files.
3. On their first push, `.github/workflows/init-template.yml` runs automatically. It:
   - Renames the placeholder project name (in `pyproject.toml`, docs, etc.) to match the new repo — here, `todo-tracker`
   - Renames the placeholder Python package to a matching valid package name — here, `todo_tracker` — including `git mv`ing the `src/` folder
   - Regenerates `uv.lock` to match
   - Commits the change and **deletes the workflow file itself**, so it only ever runs once
4. They `git pull`, then `uv sync --extra dev` as usual.

No action needed on their end beyond naming the repo — the rename happens by itself. If you'd rather rename by hand instead (e.g. you downloaded this as a zip, not via "Use this template"), see `CLEANUP.md`.

## Get started

```bash
git clone <your-repo-url>
cd python-template

# Installs Python (if needed), creates .venv, installs all deps + dev tools
uv sync --extra dev

# Confirm it works
uv run pytest
```

Expected result: tests pass. Or use the Makefile shortcuts:

```bash
make install   # uv sync --extra dev
make test      # uv run pytest
```

## Usage

```bash
uv run python -m python_template.main
# or
make run
```

```python
from python_template import greet

print(greet("World"))  # Hello, World!
```

## Development

```bash
make test        # run tests
make test-cov    # run tests with an HTML + terminal coverage report
make watch        # TDD loop: re-run tests automatically on every save
make lint         # ruff check (style, imports, bugs, docstrings)
make format       # ruff format (auto-fix)
make type-check   # mypy
make security     # bandit — scans src/ for common security issues
make all          # format + lint + type-check + security + test
make ci           # same checks, but no auto-fix (what CI runs)
```

Run `make help` to see every available command.

Ruff's `D` rules require a docstring on every public module, class, and function, in [Google style](https://google.github.io/styleguide/pyguide.html#38-comments-and-docstrings). Test files are exempt (`tests/**/*.py` is excluded in `pyproject.toml`).

### Pre-commit hooks

```bash
uv run pre-commit install   # one-time, sets up the git hook
make pre-commit              # run all hooks manually
```

## The TDD loop

This project is set up to support a red/green/refactor workflow. See **WORKFLOW.md** for the full guide with a worked example; short version:

1. **Red** — write one failing test that describes the behavior you want, and confirm it fails for the right reason.
2. **Green** — write the least code needed to make it pass, then commit.
3. **Refactor** — clean up while everything stays green, then commit again.
4. Repeat.

## Adding dependencies

```bash
uv add package-name          # runtime dependency
uv add --dev package-name    # dev-only dependency
uv remove package-name       # remove one
```

This updates `pyproject.toml` and the `uv.lock` lockfile together, so installs stay reproducible for everyone on the project.

## Project structure

```text
python-template/
├── src/python_template/          # source code
│   ├── __init__.py
│   └── main.py
├── tests/                   # tests (files named test_*.py)
│   └── test_smoke.py
├── .github/workflows/ci.yml            # CI: lint, type-check, test on 3.9 / 3.11 / 3.12
├── .github/workflows/init-template.yml # Auto-renames the project on first push, then deletes itself
├── .pre-commit-config.yaml  # local git-hook checks
├── pyproject.toml           # project metadata, dependencies, tool config
├── uv.lock                  # locked dependency versions (generated by uv)
├── Makefile                 # convenience commands
├── SETUP.md                 # detailed setup guide (one-command + manual + troubleshooting)
├── WORKFLOW.md              # TDD workflow guide
├── LICENSE                  # MIT — update the copyright holder name before you publish
└── .python-version          # Python version uv installs/uses
```

## Making it yours

Rename the package once you move past the starter stage:

1. `src/python_template` → `src/<your_package_name>`
2. Update the import in `tests/test_smoke.py`
3. In `pyproject.toml`, update `name`, `[tool.hatch.build.targets.wheel] packages`, `[tool.pytest.ini_options] --cov=`, and `[tool.coverage.run] source`
4. Update this README

## License

[MIT](LICENSE) — update the copyright holder name in `LICENSE` before you publish.

# Project Setup Guide

Get this project running in one of two ways:

| Path                                                           | Best for                                      | Effort    |
| -------------------------------------------------------------- | --------------------------------------------- | --------- |
| **[A. One-command setup](#a-one-command-setup)**               | Getting started fast                          | 1 command |
| **[B. Manual setup (full guide)](#b-manual-setup-full-guide)** | Learning each step, or when the command fails | 4 steps   |

Both paths give you the same result: a `.venv` virtual environment with all dependencies installed and passing tests. Unlike a plain `pip`/`venv` setup, uv also pins the exact Python interpreter (`.python-version`) and locks every dependency version (`uv.lock`), so this same command reproduces an identical environment on any machine.

---

## Prerequisites

**uv** — this project's one real prerequisite. It replaces `python -m venv` + `pip` + a separate Python installer:

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

**Windows (PowerShell)**

```powershell
powershell -ExecutionPolicy Bypass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

Confirm it installed:

```bash
uv --version
```

You do **not** need Python pre-installed — uv installs the version pinned in `.python-version` (3.12) automatically the first time you sync.

**Start in the project root**, the folder that contains `pyproject.toml`, `src/`, and `tests/`:

```bash
cd python-uv-project
```

> **Windows tip:** extracting the zip can create a nested folder (`python-uv-project\python-uv-project`). Run `dir` (Windows) or `ls` (macOS/Linux). If you don't see `pyproject.toml`, `cd` into the inner folder.

---

## A. One-command setup

### Run it

Identical on every OS — no separate Windows/macOS/Linux script needed, because uv itself is cross-platform:

```bash
uv sync --extra dev
```

### What the command does

1. Installs Python 3.12 if it isn't already on your machine (reads `.python-version`)
2. Creates the virtual environment (`.venv`)
3. Installs every dependency at the exact version pinned in `uv.lock`, including the dev tools (pytest, ruff, mypy, pre-commit)

Then confirm it worked:

```bash
uv run pytest
```

Expected result: `2 passed`.

### Understanding the command

| Part          | Meaning                                                                  |
| ------------- | ------------------------------------------------------------------------ |
| `uv sync`     | Makes `.venv` match `uv.lock` exactly — creates the venv if missing      |
| `--extra dev` | Also installs the `dev` optional-dependency group (test/lint/type tools) |

### After it finishes

There's nothing to activate. Every command below is run through `uv run`, which finds `.venv` automatically:

```bash
uv run pytest
uv run python -m my_project.main
```

If you'd rather activate the environment the traditional way (e.g. so your editor's interpreter picks it up), you still can:

| Shell              | Command                      |
| ------------------ | ---------------------------- |
| Windows PowerShell | `.venv\Scripts\Activate.ps1` |
| macOS / Linux      | `source .venv/bin/activate`  |

Once activated, drop the `uv run` prefix (`pytest` instead of `uv run pytest`).

### If the command fails

- Read the last error line, then check the [Troubleshooting](#troubleshooting) table.
- If you can't resolve it, use the [manual setup](#b-manual-setup-full-guide) below. It's the same work, one step at a time, so you can see exactly where things go wrong.

---

## B. Manual setup (full guide)

### Step 1. Confirm you're in the project root

```bash
cd python-uv-project
```

Run `dir` (Windows) or `ls` (macOS/Linux) and make sure you can see `pyproject.toml`.

### Step 2. Install the pinned Python version

Optional — `uv sync` does this automatically — but useful if you want to see it happen:

```bash
uv python install
```

This reads `.python-version` and downloads that exact interpreter if you don't already have it. uv manages this separately from any system Python, so it won't touch or conflict with other projects.

### Step 3. Create the environment and install dependencies

```bash
uv sync --extra dev
```

This single command replaces `python -m venv .venv` + activating it + `pip install`. It creates `.venv` in the project folder and installs every package pinned in `uv.lock`.

**Want only runtime dependencies, no dev tools?**

```bash
uv sync
```

### Step 4. Run the tests

```bash
uv run pytest
```

Expected result: `2 passed`.

Useful variations:

```bash
uv run pytest -v                                    # verbose
uv run pytest -x                                    # stop at first failure
uv run pytest --lf                                  # re-run last failures only
uv run pytest --cov --cov-report=term-missing       # coverage report
uv run ptw .                                        # watch mode: re-runs on every save
```

Or with the Makefile shortcuts: `make test`, `make test-cov`, `make watch`.

### Activating the environment (optional)

`uv run <command>` always works without activation. If you prefer an activated shell:

| Shell                            | Command                         |
| -------------------------------- | ------------------------------- |
| **Windows PowerShell**           | `.venv\Scripts\Activate.ps1`    |
| **Windows Command Prompt (cmd)** | `.venv\Scripts\activate.bat`    |
| **Windows Git Bash**             | `source .venv/Scripts/activate` |
| **macOS / Linux (bash, zsh)**    | `source .venv/bin/activate`     |

When it works, your prompt starts with `(.venv)`, and you can drop the `uv run` prefix.

**PowerShell says "running scripts is disabled"?** Allow scripts for the current terminal session only (nothing permanent changes):

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.venv\Scripts\Activate.ps1
```

Deactivate the same way as any venv:

```bash
deactivate
```

---

## Every day after setup

You never repeat setup. Just:

```bash
uv run pytest          # or: make test
uv run ptw .            # watch mode, or: make watch
```

No activation step required. If someone else adds a dependency and you pull their changes, run `uv sync --extra dev` again to catch up — it's fast and safe to run repeatedly.

---

## Adding or updating dependencies

Don't hand-edit `pyproject.toml`'s dependency lists — let uv keep `uv.lock` in sync:

```bash
uv add package-name          # runtime dependency
uv add --dev package-name    # dev-only dependency
uv remove package-name       # remove one
uv lock --upgrade             # upgrade everything to latest allowed versions
```

---

## Troubleshooting

| Problem                               | Fix                                                                                              |
| ------------------------------------- | ------------------------------------------------------------------------------------------------ |
| `uv: command not found`               | Re-run the install command above, then open a new terminal (it updates your PATH)                |
| `error: No such file: pyproject.toml` | Wrong folder. Run `dir` / `ls` and `cd` to the folder containing `pyproject.toml`                |
| `pytest: command not found`           | You're not using `uv run` and haven't activated `.venv`. Use `uv run pytest` instead             |
| `ModuleNotFoundError: my_project`     | Run `uv run pytest` from the project root. `pyproject.toml` sets `pythonpath = ["src"]`          |
| Scripts disabled in PowerShell        | Use `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` (see Step 3)                    |
| Wrong Python version picked up        | Delete `.venv` and re-run `uv sync --extra dev` — uv reinstalls the version in `.python-version` |
| Want a fresh start                    | Delete the `.venv` folder, then run `uv sync --extra dev` again                                  |
| Coverage failure (`fail_under=100`)   | Expected once you write new code without tests — that's this starter enforcing the TDD loop      |

---

## Quick reference

**Any OS: one command**

```bash
uv sync --extra dev
uv run pytest
```

**Any OS: manual, step by step**

```bash
uv python install
uv sync --extra dev
uv run pytest
```

**Optional: activate instead of using `uv run`**

```bash
source .venv/bin/activate        # macOS/Linux
.venv\Scripts\Activate.ps1       # Windows PowerShell
pytest
```

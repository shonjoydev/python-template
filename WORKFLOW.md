# TDD Workflow

How to work on this project day to day. Setup is covered in `README.md`. This file is about what you do _after_ setup.

## The loop

```
   🔴 RED            🟢 GREEN           🔵 REFACTOR
 write ONE     →   write the least  →   clean up while
 failing test      code to pass         tests stay green
      ↑                                        │
      └────────────────────────────────────────┘
                 commit, then repeat
```

**Three rules**

1. Never write production code unless a failing test demands it.
2. Write only enough of a test to fail, and only enough code to pass.
3. Refactor only when all tests are green, and never mix refactoring with new behavior.

---

## Start of every session

Open two terminals in the project root. Since uv manages the environment, there's nothing to activate — just prefix commands with `uv run`.

**Terminal 1: run and watch tests**

```bash
make watch
# equivalent to: uv run ptw .
```

**Terminal 2: git and one-off commands**

```bash
git status
uv add some-package   # if you need a new dependency mid-session
```

Your editor is the third piece. Save a file and Terminal 1 re-runs the tests automatically.

---

## One cycle, step by step

### 1. 🔴 Red: write one failing test

- Put it in `tests/test_<thing>.py`. Test files must start with `test_`, and test functions must start with `test_`.
- Name the test after the behavior: `test_pop_from_empty_stack_raises`, not `test_pop2`.
- Save, and **watch it fail**. Confirm it fails for the _right reason_ (the feature is missing, not a typo or bad import). A test you've never seen fail proves nothing.

### 2. 🟢 Green: make it pass

- Write the simplest code that passes. Hard-coding a return value is allowed if it makes the test pass. The next test will force the real logic.
- Don't add anything the tests don't ask for.
- Save. When Terminal 1 is green, commit:

```bash
git add -A
git commit -m "stack: pop returns last pushed item"
```

### 3. 🔵 Refactor: clean up

- Remove duplication, improve names, simplify.
- Save after each small change. If anything goes red, undo the last change.
- Commit again if you changed something: `git commit -am "refactor: simplify pop"`.

### 4. Repeat

Pick the next smallest behavior and go back to Red.

---

## Worked example: a `Stack`

Assumes your package is `src/python_template/` (rename to yours).

**Cycle 1: empty stack**

🔴 `tests/test_stack.py`

```python
from python_template.stack import Stack


def test_new_stack_is_empty():
    assert Stack().is_empty()
```

Fails with `ModuleNotFoundError`. That's the right reason: the module doesn't exist yet.

🟢 `src/python_template/stack.py`

```python
class Stack:
    def is_empty(self):
        return True
```

**Cycle 2: push**

🔴

```python
def test_push_makes_stack_non_empty():
    s = Stack()
    s.push(1)
    assert not s.is_empty()
```

Fails: no `push` method.

🟢

```python
class Stack:
    def __init__(self):
        self._items = []

    def is_empty(self):
        return not self._items

    def push(self, item):
        self._items.append(item)
```

**Cycle 3: pop**

🔴

```python
def test_pop_returns_last_pushed_item():
    s = Stack()
    s.push(1)
    s.push(2)
    assert s.pop() == 2
```

🟢 add to the class:

```python
    def pop(self):
        return self._items.pop()
```

**Cycle 4: pop on empty**

🔴

```python
import pytest


def test_pop_from_empty_stack_raises():
    with pytest.raises(IndexError):
        Stack().pop()
```

This may already pass, because `list.pop()` raises `IndexError` on an empty list. That's fine. Keep it as a documented boundary, but check it isn't vacuous by temporarily breaking the code to see it fail. If you want a clearer message, that's the next red test.

**Refactor:** merge repeated setup into a helper or `pytest.fixture`, and use `@pytest.mark.parametrize` for similar cases.

---

## Before you finish for the day

Run the full check once:

```bash
make ci
# equivalent to: uv run ruff format --check . && uv run ruff check . && uv run mypy src/ && uv run pytest --cov
```

- All tests pass
- Coverage meets the threshold set in `pyproject.toml` (`fail_under = 100`). The report lists any lines your tests never reached
- `git status` is clean, with everything committed

---

## Handy commands

| Goal                             | Command                     |
| -------------------------------- | --------------------------- |
| Watch mode (auto re-run on save) | `make watch`                |
| Run all tests once               | `make test`                 |
| Verbose output                   | `uv run pytest -v`          |
| Stop at first failure            | `uv run pytest -x`          |
| Re-run only last failures        | `uv run pytest --lf`        |
| Run one test by name             | `uv run pytest -k test_pop` |
| Show `print()` output            | `uv run pytest -s`          |
| Debug a failure                  | `uv run pytest --pdb`       |
| Coverage report                  | `make test-cov`             |
| Lint                             | `make lint`                 |
| Format                           | `make format`               |
| Type check                       | `make type-check`           |

---

## When you find a bug

1. Write a **failing test that reproduces it**. Don't touch production code yet.
2. Watch it fail.
3. Fix the code until it passes.
4. Commit the test and the fix together.

The bug can't quietly return, because the test now guards it.

---

## Common mistakes

| Mistake                               | Better                                    |
| ------------------------------------- | ----------------------------------------- |
| Writing several tests before any code | One failing test at a time                |
| Never seeing the test fail            | Always watch red first                    |
| Testing internals (`_items`)          | Test behavior through the public methods  |
| Big steps ("build the whole feature") | Smallest possible behavior per cycle      |
| Refactoring while red                 | Get to green first, then refactor         |
| Committing red code                   | Commit only on green                      |
| Skipping the refactor step            | Cleanup is part of the loop, not optional |

---

## About the CI workflow (GitHub Actions)

The project includes `.github/workflows/ci.yml`. It runs on every push and pull request against `main`: it installs uv, syncs dependencies for Python 3.9, 3.11, and 3.12, then runs formatting checks, linting, type-checking, and the test suite with coverage. It only does anything once you push the project to GitHub — locally you can ignore it.

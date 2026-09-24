# Cleanup Checklist: Starter → Real Project

Do this **once**, after setup works and before your real work begins. **Delete this file when you finish** (last item below) — it's a to-do list, not project documentation.

> **Generated this repo via GitHub's "Use this template" button?** Section 1 below already happened for you automatically (see the "Using this as a GitHub template" section in `README.md`) — check that `git log` shows an `[init-template]` commit, confirm `pyproject.toml` no longer says the placeholder name, then skip straight to section 2.

---

## 1. Rename and update

Skip this section if the automated template workflow already did it for you (see the note above).

- [ ] **Rename the package folder**: `src/my_project` → `src/<your_package_name>`

  ```bash
  git mv src/my_project src/your_package_name
  ```

- [ ] **Update `tests/test_smoke.py`**: change `import my_project` and `my_project.__version__` to your package name
- [ ] **Update `src/your_package_name/main.py`**: change `from my_project import greet`
- [ ] **Update `pyproject.toml`**:
  - `name = "my-project"` → your project name
  - `[tool.hatch.build.targets.wheel] packages = ["src/my_project"]` → your package path
  - `[tool.pytest.ini_options] addopts` — the `--cov=src/my_project` entry
  - `[tool.coverage.run] source = ["src/my_project"]`
- [ ] Run `uv run pytest` and confirm it still passes before moving on

---

## 2. Remove the learning aids

These guides teach setup and TDD. They don't belong in a real project.

- [ ] Delete `WORKFLOW.md`
- [ ] _(Optional)_ Keep it if teammates are new to TDD — just move it to a notes folder outside the repo instead of deleting.

```bash
rm WORKFLOW.md
```

---

## 3. Rewrite the README

- [ ] Replace the contents of `README.md` with something about _your_ project — what it does, who it's for, and a short usage example. Keep the `uv sync --extra dev` / `make test` quickstart, since that part doesn't change.

---

## 4. Update the license

- [ ] Open `LICENSE` and replace `Your Name` with your name or organization, and check the year.

---

## 5. Keep these as they are

| File                         | Why                                                                          |
| ---------------------------- | ---------------------------------------------------------------------------- |
| `pyproject.toml` / `uv.lock` | Dependency + tool config, and the reproducible lockfile                      |
| `.gitignore`                 | Keeps `.venv` and caches out of git                                          |
| `.github/workflows/ci.yml`   | Runs lint/type-check/test on every push. Delete only if you don't use GitHub |
| `.pre-commit-config.yaml`    | Local pre-push checks                                                        |
| `Makefile`                   | Convenience commands (`make test`, `make lint`, ...)                         |
| `tests/` and `src/`          | Your actual project                                                          |

Never commit `.venv/`. It's already ignored, and it's machine-specific — uv recreates it from `uv.lock` on any machine with `uv sync`.

---

## 6. Finish

- [ ] `uv run pytest` passes
- [ ] `git status` shows only changes you intended
- [ ] Commit:

  ```bash
  git add -A
  git commit -m "chore: turn starter into project"
  ```

- [ ] **Delete this file** (`CLEANUP.md`) and commit again

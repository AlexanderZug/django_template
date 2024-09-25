#
# help text for this module
#
help_python:
	@echo ""
	@echo "-------------------- Python: Maintenance --------------------------"
	@echo "make requirements ------------- Write dependency lock file"
	@echo "make requirements-up ---------- Upgrade dependencies and create a new commit"
	@echo "make sync --------------------- Sync installed dependencies with lock file"
	@echo ""
	@echo "-------------------- Python: Environment Setup --------------------"
	@echo "make venv-setup --------------- Set up the python VENV for this project"
	@echo "make venv-delete -------------- Delete VENV specified in Makefile"
	@echo "make venv-install ------------- Install VENV with desired python version and sync dependencies"
	@echo "make venv-update -------------- Update basic python tooling like pip, etc,"
	@echo "make venv-reset --------------- Reinstall VENV based on new python-version in Makefile"
	@echo ""
	@echo "-------------------- Python: Tests --------------------------------"
	@echo "make lint --------------------- Run ruff tests"
	@echo "make mypy --------------------- Run mypy tests"
	@echo "make test --------------------- Run all tests"

#
# maintenance targets
#
requirements: venv-update
	@echo "executing target requirements"
	@poetry lock --no-update

requirements-up: venv-update
	@echo "executing target requirements-up"
	@poetry update
	@git commit -m "Update python dependencies" -- \
	poetry.lock

sync: venv-update
	@echo "executing target sync"
	@poetry install --sync

#
# setup targets
#
venv-setup: venv-install

venv-delete:
	@echo "executing target venv-delete"
	@poetry env remove ${PYTHON_VERSION} || poetry env remove $(poetry env info --path)

venv-install:
	@echo "executing target venv-install"
	@poetry env use ${PYTHON_VERSION}  # Устанавливаем нужную версию Python, если она еще не установлена
	@poetry install                    # Устанавливаем зависимости из poetry.lock или pyproject.toml
	@poetry shell                      # Активируем виртуальное окружение
	@${MAKE} -s venv-update            # Продолжаем с другими действиями, если требуется
	@${MAKE} -s sync

venv-update:
	@poetry update

venv-reset: venv-delete venv-install

#
# test targets
#
lint:
	@echo "executing target lint"
	@ruff check ${APPFOLDER}/

mypy:
	@echo "executing target mypy"
	@mypy ${APPFOLDER}/

.ONESHELL:
test:
	@echo "executing target test"
	FAILED=0
	${MAKE} -s lint || FAILED=1
	${MAKE} -s mypy || FAILED=1
	exit  $$FAILED

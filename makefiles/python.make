#
# help text for this module
#
help_python:
	@echo ""
	@echo "-------------------- Python: Maintenance --------------------------"
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

sync:
	@echo "executing target sync"
	@uv sync

#
# setup targets
#
venv-setup: venv-install

venv-delete:
	@echo "executing target venv-delete"
	@uv python uninstall ${PYTHON_VERSION}
	@rm -rf .venv
	@@rm -rf .venv
	@uv cache clean --venv

venv-install:
	@echo "executing target venv-install"
	@uv python install ${PYTHON_VERSION}
	@uv venv --clear

venv-update:
	@uv sync

venv-reset: venv-delete venv-install

#
# test targets
#
lint:
	@echo "executing target lint"
	@ruff check ${APPFOLDER}/

mypy:
	@echo "executing target mypy"
	@cd ${APPFOLDER} && mypy .

run-test:
	@echo "executing target run-test"
	@pytest -v ${APPFOLDER}/tests

.ONESHELL:
test:
	@echo "executing target test"
	FAILED=0
	${MAKE} -s lint || FAILED=1
	${MAKE} -s mypy || FAILED=1
	${MAKE} -s run-test || FAILED=1
	exit  $$FAILED

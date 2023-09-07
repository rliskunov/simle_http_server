.PHONY: run-server run-tests docker-build docker-run docker-compose-build docker-compose-up docker-scan install-trivy

# Variables
VENV_NAME=venv
PYTHON=${VENV_NAME}/bin/python
PIP=${VENV_NAME}/bin/pip
DOCKER_IMAGE_NAME=simle_http_server

install:
	@test -d ${VENV_NAME} || python -m venv ${VENV_NAME}
	@${PIP} install -r requirements.dev.txt

run-tests:
	${VENV_NAME}/bin/pytest tests/tests.py

run-server: run-tests
	@${VENV_NAME}/bin/uvicorn app.main:app --reload

hadolint:
	@hadolint Dockerfile

docker-build: hadolint
	@docker build . -t ${DOCKER_IMAGE_NAME}

docker-run: docker-build
	@docker run -d -p 8000:8000 ${DOCKER_IMAGE_NAME}

docker-scan:
	@trivy image --severity HIGH,CRITICAL ${DOCKER_IMAGE_NAME}

docker-compose-build:
	@docker-compose build

docker-compose-up: docker-compose-build
	@docker-compose up -d
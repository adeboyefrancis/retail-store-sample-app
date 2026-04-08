# Standardize Makefile for Spring Boot projects
# This Makefile provides common commands for Spring Boot projects, including:
# - install: Install dependencies
# - run: Start the application
# - test: Run tests
# - lint: Run Checkstyle to check for code quality issues
# - clean: Remove build artifacts

# ═══════════════════════════════════════════════════════════════
# Makefile — Spring Boot Application
# ═══════════════════════════════════════════════════════════════

.PHONY: help install dev build lint test check clean check-all \
		docker-login build-image run-container push-images pull-images docker-exec docker-clean

# Colors for output
YELLOW := \033[0;33m
GREEN  := \033[0;32m
RED    := \033[0;31m
NC     := \033[0m

DOCKER_REPO := adeboyefrancis88
IMAGE_NAME := img-frontend-ui
CONTAINER_NAME := frontend-app
TAG_VERSION := v1.0.0
HOST_PORTS := [8888,8889]
CONTAINER_PORT := 8080

# Default target
help: ## Show available commands
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

# ═══════════════════════════════════════════════════════════════
# Runtime Tests and Checks
# ═══════════════════════════════════════════════════════════════

check-all: lint test
	@echo "$(YELLOW) Running lint and test checks...$(NC)"
	@$(MAKE) lint
	@$(MAKE) test


install: ## Install Maven dependencies
	@echo "Installing dependencies...[1/6]"
	@./mvnw dependency:resolve
	@echo "$(GREEN)✅ Dependencies installed$(NC)"


dev: ## Run Spring Boot in development mode
	@echo "Starting Spring Boot development server...[2/6]"
	@./mvnw spring-boot:run


build: ## Build the application JAR
	@echo "Building application...[3/6]"
	@./mvnw clean package -DskipTests
	@echo "$(GREEN)✅ Build complete — output in target/$(NC)"

lint: ## Run Checkstyle linter
	@echo "Running Checkstyle...[4/6]"
	@./mvnw checkstyle:check || (echo "$(RED)🚫 Checkstyle failed.$(NC)" && exit 1)
	@echo "$(GREEN)✅ Linting complete$(NC)"

test: ## Run unit tests
	@echo "Running tests...[5/6]"
	@./mvnw test || (echo "$(RED)🚫 Tests failed.$(NC)" && exit 1)
	@echo "$(GREEN)✅ Tests complete$(NC)"

check: check-all ## Run all checks (mirrors pre-push guardrails)
	@echo "$(GREEN)✅ All checks passed — safe to push$(NC)"

clean: ## Remove build artifacts
	@echo "Cleaning..."
	@./mvnw clean
	@echo "✅ Clean complete"


# ═══════════════════════════════════════════════════════════════
# Docker Orchestration for Frontend UI (Application)
# ═══════════════════════════════════════════════════════════════
docker-login: ## Docker Login
	@echo "Login to Docker Hub via CLI locally"
	@docker login -u ${DOCKER_REPO}

build-image: ## Build Docker image locally
	@echo "Build Docker New docker Image locally...."
	@docker build -t ${IMAGE_NAME}:${TAG_VERSION} .

run-container: ## Run Image as a Container
	@echo "Running Container using built image...."
	@docker run --name ${CONTAINER_NAME} -p ${HOST_PORTS[0]}:${CONTAINER_PORT} -d ${IMAGE_NAME}:${TAG_VERSION}

push-images: ## Tag & Push Image to Docker Hub
	@echo "Tagging Docker image"
	@docker tag ${IMAGE_NAME}:${TAG_VERSION} ${DOCKER_REPO}/${IMAGE_NAME}:${TAG_VERSION}

	@echo "Pushing Tagged Image to Docker Registry"
	@docker push ${DOCKER_REPO}/${IMAGE_NAME}:${TAG_VERSION}

pull-images: ## Pull Docker Images
	@echo "Pulling docker Image...."
	@docker pull ${DOCKER_REPO}/${IMAGE_NAME}:${TAG_VERSION}


docker-exec: ## Connect to Docker Container via Terminal
	@docker exec -it ${CONTAINER_NAME} /bin/sh

docker-clean: ## Stop Container && Remove Image
# Stop Docker Container
	@echo "Stopping Container...."
	@docker stop ${CONTAINER_NAME}

# Remove Docker Container
	@echo "Removing Container...."
	@docker rm ${CONTAINER_NAME}

# Remove Docker Images
	@echo "Removing Image from Local Host /var/lib/docker/image"
	@docker rmi ${IMAGE_NAME}:${TAG_VERSION}
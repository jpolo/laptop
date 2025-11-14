
## Docker compose file
DOCKER_COMPOSE_FILE ?=
ifeq ($(DOCKER_COMPOSE_FILE),)
# If DOCKER_COMPOSE_FILE is not set, detect compose file from file name in ./ and .docker/
	.DOCKER_COMPOSE_FILES := compose-dev.yaml compose.yaml docker-compose.yml
	DOCKER_COMPOSE_FILE = $(firstword $(wildcard $(.DOCKER_COMPOSE_FILES) $(addprefix .docker/,$(.DOCKER_COMPOSE_FILES))))
endif

# Docker Compose command
DOCKER_COMPOSE := docker compose
ifneq ($(DOCKER_COMPOSE_FILE),)
	DOCKER_COMPOSE += -f $(DOCKER_COMPOSE_FILE)
endif

DOCKER_COMPOSE_MAIN_SERVICE ?= web

.PHONY: docker-compose-run
docker-compose-run: export DOCKER_BUILD_TARGET ?= $(CONTAINER_BUILDER_TARGET)
docker-compose-run: export APP_IMAGE = $(CONTAINER_BUILDER_IMAGE):$(CONTAINER_BUILDER_TAG)
docker-compose-run: export COMPOSE_PROJECT_NAME ?= $(CI_PROJECT_NAME)-$(shell date '+%Y%m%d%H%M%S')
docker-compose-run:
	@ cleanup() { $(call log,info,[Docker Compose] Stopping...,1);$(DOCKER_COMPOSE) down --volumes --remove-orphans &>/dev/null; } \
	&& trap cleanup EXIT INT QUIT TERM \
	&& $(call log,info,[Docker Compose] Starting...,1) \
	&& $(DOCKER_COMPOSE) up --detach --remove-orphans --quiet-pull \
  && $(call log,info,[Docker Compose] Executing command...,1) \
	&& $(DOCKER_COMPOSE) run --use-aliases --rm $(DOCKER_RUN_ARGS) $(DOCKER_COMPOSE_MAIN_SERVICE) $(DOCKER_COMMAND);

.PHONY: docker-compose-make-%
docker-compose-make-%:
	@$(MAKE) docker-compose-run DOCKER_COMMAND="make $*"

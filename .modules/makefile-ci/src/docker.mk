
## Enable Docker buildx feature
DOCKER_BUILDKIT ?= 1
export DOCKER_BUILDKIT

## Docker Daemon socket path
DOCKER_SOCKET_PATH ?= /var/run/docker.sock
export DOCKER_SOCKET_PATH

## Enable CLI hints (docker scout)
DOCKER_CLI_HINTS ?= false
export DOCKER_CLI_HINTS

## Docker build progress display
DOCKER_BUILDKIT_PROGRESS ?= auto
export DOCKER_BUILDKIT_PROGRESS

## Docker build platform (ex: linux/arm64)
DOCKER_BUILD_PLATFORMS ?=
export DOCKER_BUILD_PLATFORMS

## Enable Docker push when building
DOCKER_BUILD_PUSH ?=
ifeq ($(DOCKER_BUILD_PUSH),)
	ifneq ($(call filter-false,$(CI)),)
# Enable DOCKER_BUILD_PUSH by default when CI is set
		DOCKER_BUILD_PUSH = 1
	endif
endif
export DOCKER_BUILD_PUSH

ifneq ($(CI_REGISTRY_IMAGE),)
CI_REGISTRY_IMAGE_PREFIX := $(CI_REGISTRY_IMAGE)/
endif

## Container dev envs image repository (for CI)
CONTAINER_DEV_IMAGE ?= $(CI_REGISTRY_IMAGE_PREFIX)dev
## Container dev envs image target (for CI)
CONTAINER_DEV_TARGET ?= dev-envs
## Containerdev envs image tag  (for CI)
CONTAINER_DEV_TAG ?=
ifeq ($(CONTAINER_DEV_TAG),)
	ifneq ($(call filter-false,$(CI)),)
		CONTAINER_DEV_TAG = $(CI_COMMIT_REF_SLUG)-$(CI_COMMIT_SHORT_SHA)--$(CONTAINER_DEV_TARGET)
	else
		CONTAINER_DEV_TAG = local--$(CONTAINER_DEV_TARGET)
	endif
endif

## Container builder image repository (for CI)
CONTAINER_BUILDER_IMAGE ?= $(CI_REGISTRY_IMAGE_PREFIX)dev
## Container builder image target (for CI)
CONTAINER_BUILDER_TARGET ?= builder
## Container builder image tag  (for CI)
CONTAINER_BUILDER_TAG ?=
ifeq ($(CONTAINER_BUILDER_TAG),)
	ifneq ($(call filter-false,$(CI)),)
		CONTAINER_BUILDER_TAG = $(CI_COMMIT_REF_SLUG)-$(CI_COMMIT_SHORT_SHA)--$(CONTAINER_BUILDER_TARGET)
	else
		CONTAINER_BUILDER_TAG = local--$(CONTAINER_BUILDER_TARGET)
	endif
endif

## Container runner image repository (for server)
CONTAINER_RUNNER_IMAGE ?= $(CONTAINER_BUILDER_IMAGE)
## Container runner image target (for server)
CONTAINER_RUNNER_TARGET ?= runner
## Container runner image tag (for server)
CONTAINER_RUNNER_TAG ?=
ifeq ($(CONTAINER_RUNNER_TAG),)
	ifneq ($(call filter-false,$(CI)),)
		CONTAINER_RUNNER_TAG = $(CI_COMMIT_REF_SLUG)-$(CI_COMMIT_SHORT_SHA)--$(CONTAINER_RUNNER_TARGET)
	else
		CONTAINER_RUNNER_TAG = local--$(CONTAINER_RUNNER_TARGET)
	endif
endif

## Release Docker image repository
CONTAINER_RELEASE_IMAGE ?= $(CI_REGISTRY_IMAGE)
## Release Docker image tag
CONTAINER_RELEASE_TAG ?= 1.$(shell echo "$(CI_COMMIT_TIMESTAMP)" | cut -c 1-19 | sed 's/[:-]//g;s/T/./g')-sha.$(CI_COMMIT_SHORT_SHA)

DOCKER_LABEL_VARIABLES := \
	CI_COMMIT_AUTHOR \
	CI_COMMIT_REF_NAME \
	CI_COMMIT_REF_SLUG \
	CI_COMMIT_SHA \
	CI_COMMIT_SHORT_SHA \
	CI_COMMIT_TIMESTAMP \
	CI_JOB_ID \
	CI_JOB_URL \
	CI_PIPELINE_ID \
	CI_PIPELINE_IID \
	CI_PIPELINE_URL \
	CI_PROJECT_ID \
	CI_PROJECT_PATH_SLUG \
	CI_PROJECT_URL \
	CI_REPOSITORY_URL \
	CI_RUNNER_ID \
	CI_RUNNER_REVISION \
	CI_RUNNER_TAGS

DOCKER_ENV_VARIABLES := $(CI_VARIABLES) \
	TIMEOUT_SECONDS \
	DOCKER_SOCKET_PATH

# Construct --label flags

# DOCKER_BUILD_ARGS
DOCKER_BUILD_ARGS_VARIABLES := \
	RUBY_VERSION \
	BUNDLER_VERSION \
	NODEJS_VERSION \
	CI_BUILD_TYPE

DOCKER_BUILD_ARGS := $(foreach var,$(DOCKER_BUILD_ARGS_VARIABLES),$(if $($(var)), --build-arg $(var)="$($(var))"))
# Append inline cache
# We use cache-to=type=inline
# DOCKER_BUILD_ARGS += --build-arg BUILDKIT_INLINE_CACHE=${BUILDKIT_INLINE_CACHE:-1}
# Append labels
DOCKER_BUILD_ARGS += $(foreach var,$(DOCKER_LABEL_VARIABLES),$(if $($(var)), --label $(var)="$($(var))"))
# Append progress arguments
DOCKER_BUILD_ARGS += --progress=$(DOCKER_BUILDKIT_PROGRESS)
# Append build platform
ifneq ("$(DOCKER_BUILD_PLATFORMS)","")
DOCKER_BUILD_ARGS += --platform="$(DOCKER_BUILD_PLATFORMS)"
endif

DOCKER_RUN_ARGS :=
# Append env
DOCKER_RUN_ARGS += $(foreach var,$(DOCKER_ENV_VARIABLES),$(if $($(var)), --env $(var)))

.PHONY: docker-login
docker-login: ## Login to $CI_REGISTRY (username=$CI_REGISTRY_USER, password=$CI_REGISTRY_PASSWORD)
	@${MAKE} .docker-login \
		DOCKER_REGISTRY="$(CI_REGISTRY)" \
		DOCKER_USERNAME='$(call escape-shell,$(CI_REGISTRY_USER))' \
		DOCKER_PASSWORD='$(call escape-shell,$(CI_REGISTRY_PASSWORD))'

.PHONY: docker-build
docker-build: docker-image-dev docker-image-builder docker-image-runner ## Build docker image (and push cache tags)

docker-image-dev:
	@${MAKE} .docker-pull-cache .docker-build \
		DOCKER_BUILD_CACHE_TO="$(CONTAINER_DEV_IMAGE):$(CI_COMMIT_REF_SLUG)-cache--$(CONTAINER_DEV_TARGET)" \
		DOCKER_BUILD_CACHE_FROM="\
			$(CONTAINER_DEV_IMAGE):$(CI_COMMIT_REF_SLUG)-cache--$(CONTAINER_DEV_TARGET) \
			$(CONTAINER_DEV_IMAGE):$(CI_DEFAULT_BRANCH)-cache--$(CONTAINER_DEV_TARGET)" \
		DOCKER_BUILD_TAG="$(CONTAINER_DEV_IMAGE):$(CONTAINER_DEV_TAG)" \
		DOCKER_BUILD_TAGS="$(CONTAINER_DEV_IMAGE):$(CI_COMMIT_REF_SLUG)-cache--$(CONTAINER_DEV_TARGET)" \
		DOCKER_BUILD_TARGET="$(CONTAINER_DEV_TARGET)"

docker-image-builder: docker-image-dev
	@${MAKE} .docker-pull-cache .docker-build \
		DOCKER_BUILD_CACHE_TO="$(CONTAINER_BUILDER_IMAGE):$(CI_COMMIT_REF_SLUG)-cache--$(CONTAINER_BUILDER_TARGET)" \
		DOCKER_BUILD_CACHE_FROM="\
			$(CONTAINER_BUILDER_IMAGE):$(CI_COMMIT_REF_SLUG)-cache--$(CONTAINER_BUILDER_TARGET) \
			$(CONTAINER_BUILDER_IMAGE):$(CI_DEFAULT_BRANCH)-cache--$(CONTAINER_BUILDER_TARGET)" \
		DOCKER_BUILD_TAG="$(CONTAINER_BUILDER_IMAGE):$(CONTAINER_BUILDER_TAG)" \
		DOCKER_BUILD_TAGS="$(CONTAINER_BUILDER_IMAGE):$(CI_COMMIT_REF_SLUG)-cache--$(CONTAINER_BUILDER_TARGET)" \
		DOCKER_BUILD_TARGET="$(CONTAINER_BUILDER_TARGET)"

docker-image-runner: docker-image-builder
	@${MAKE} .docker-pull-cache .docker-build \
		DOCKER_BUILD_CACHE_TO="$(CONTAINER_RUNNER_IMAGE):$(CI_COMMIT_REF_SLUG)-cache--$(CONTAINER_RUNNER_TARGET)" \
		DOCKER_BUILD_CACHE_FROM="\
			$(CONTAINER_RUNNER_IMAGE):$(CI_COMMIT_REF_SLUG)-cache--$(CONTAINER_RUNNER_TARGET) \
			$(CONTAINER_RUNNER_IMAGE):$(CI_DEFAULT_BRANCH)-cache--$(CONTAINER_RUNNER_TARGET)" \
		DOCKER_BUILD_TAG="$(CONTAINER_RUNNER_IMAGE):$(CONTAINER_RUNNER_TAG)" \
		DOCKER_BUILD_TAGS="$(CONTAINER_RUNNER_IMAGE):$(CI_COMMIT_REF_SLUG)-cache--$(CONTAINER_RUNNER_TARGET)" \
		DOCKER_BUILD_TARGET="$(CONTAINER_RUNNER_TARGET)"

.PHONY: docker-make-%
docker-make-%:
	@$(MAKE) docker-run \
		DOCKER_COMMAND="make $*"

.PHONY: docker-run
docker-run:
	@$(MAKE) .docker-run \
		DOCKER_IMAGE="$(CONTAINER_BUILDER_IMAGE)" \
		DOCKER_TAG="$(CONTAINER_BUILDER_TAG)" \
		DOCKER_COMMAND="$(DOCKER_COMMAND)"

.PHONY: docker-release
docker-release: ## Tag and push Docker Release image ($CONTAINER_RELEASE_IMAGE:$CONTAINER_RELEASE_TAG)
	docker pull "$(CONTAINER_RUNNER_IMAGE):$(CONTAINER_RUNNER_TAG)"
	docker tag "$(CONTAINER_RUNNER_IMAGE):$(CONTAINER_RUNNER_TAG)" "$(CONTAINER_RELEASE_IMAGE):$(CONTAINER_RELEASE_TAG)"
	docker push "$(CONTAINER_RELEASE_IMAGE):$(CONTAINER_RELEASE_TAG)"

.PHONY: docker-rescue
docker-rescue:
	@$(call log,info,"[Docker] Clean all unused docker images...",1)
	@$(call log,warn,"[Docker] NotImplemented",1)
#	$(Q)docker image prune -a
.rescue:: docker-rescue

# Generic target for building an image
.PHONY: .docker-build
.docker-build:
	@$(call log,info,"[Docker] Building Image tag=$(DOCKER_BUILD_TAG) target=$(DOCKER_BUILD_TARGET)",1)
	$(Q)docker buildx build\
		$(DOCKER_BUILD_ARGS)\
		--target "$(DOCKER_BUILD_TARGET)" \
		$(shell [[ -z "$(DOCKER_BUILD_PUSH)" ]] || echo --push) \
		$(foreach cache_to, $(DOCKER_BUILD_CACHE_TO), --cache-to type=inline,mode=max,ref=$(cache_to)) \
		$(foreach cache_from, $(DOCKER_BUILD_CACHE_FROM), --cache-from $(cache_from)) \
		$(foreach tag, $(DOCKER_BUILD_TAG) $(DOCKER_BUILD_TAGS), --tag $(tag)) \
		.

# Generic target to log in docker registry
.PHONY: .docker-login
.docker-login:
	@if [[ -z "$(DOCKER_REGISTRY)" || -z "$(DOCKER_USERNAME)" ]];then \
		$(call log,warn,"[Docker] Login skipped \(registry=$(DOCKER_REGISTRY), username=$(DOCKER_USERNAME), password=$(call mask-password,$(DOCKER_PASSWORD))\) \(Reason: Empty Credential\)",1) \
	else \
		$(call log,info,"[Docker] Login \(registry=$(DOCKER_REGISTRY), username=$(DOCKER_USERNAME), password=$(call mask-password,$(DOCKER_PASSWORD))\)...",1); \
		echo '$(call escape-shell,$(DOCKER_PASSWORD))' | docker login --username '$(call escape-shell,$(DOCKER_USERNAME))' --password-stdin '$(call escape-shell,$(DOCKER_REGISTRY))'; \
	fi;

# Generic target for pulling images
.PHONY: .docker-pull-cache
.docker-pull-cache:
	@$(call log,info,"[Docker] Pulling cache...",1)
	@for image in $(DOCKER_BUILD_CACHE_FROM); do \
		docker pull $$image &>/dev/null && { echo "[Docker] $$image found"; break; } || echo "[Docker] $$image not found, skipping."; \
	done

# Generic Docker run
.PHONY: .docker-run
.docker-run:
	@$(call log,info,"[Docker] Open container...",1)
	$(Q)docker run\
		$(DOCKER_RUN_ARGS) \
		--rm \
		--pull missing \
		--quiet \
		--volume "$(DOCKER_SOCKET_PATH)":/var/run/docker.sock \
		"$(DOCKER_IMAGE):$(DOCKER_TAG)" /bin/bash -c "set -euo pipefail; $(DOCKER_COMMAND)"

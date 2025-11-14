# Project paths

ifeq ($(ASDF),)
	ASDF := asdf
endif
ifeq ($(MKDIRP),)
	MKDIRP := mkdir -p
endif
ifeq ($(TOUCH),)
	TOUCH := touch
endif
ifeq ($(GIT),)
	GIT := git
endif
ifeq ($(BUNDLE),)
	BUNDLE := bundle
endif
ifeq ($(DATE),)
	DATE := date
endif

## Project root path
PROJECT_PATH ?= $(CURDIR)
## Project cache path
PROJECT_CACHE_PATH ?= .cache

# Continuous Integration

## Available for all jobs executed in CI/CD. true when available.
CI ?=

# Well known default branch list
.CI_DEFAULT_BRANCH_LIST := main master

.CI_DEFAULT_BRANCH := $(firstword $(foreach var,$(.CI_DEFAULT_BRANCH_LIST), $(filter $(var),$(shell ${GIT} branch --list))))
## The name of the project’s default branch.
CI_DEFAULT_BRANCH ?= $(.CI_DEFAULT_BRANCH)

.CI_COMMIT_BRANCH := $(shell ${GIT} rev-parse --abbrev-ref HEAD)
## The commit branch name
CI_COMMIT_BRANCH ?= $(.CI_COMMIT_BRANCH)

.CI_COMMIT_AUTHOR := $(shell ${GIT} log -1 --format='%an <%ae>')
## The author of the commit in Name <email> format
CI_COMMIT_AUTHOR ?= $(.CI_COMMIT_AUTHOR)

## The branch or tag name for which project is built
CI_COMMIT_REF_NAME ?= $(CI_COMMIT_BRANCH)

## CI_COMMIT_REF_NAME in lowercase, shortened to 63 bytes
CI_COMMIT_REF_SLUG ?= $(call slugify, $(CI_COMMIT_REF_NAME))

.CI_COMMIT_SHA := $(shell ${GIT} rev-parse HEAD)
## The commit revision the project is built for
CI_COMMIT_SHA ?= $(.CI_COMMIT_SHA)

.CI_COMMIT_SHORT_SHA := $(shell ${GIT} rev-parse --short HEAD)
## The first eight characters of CI_COMMIT_SHA
CI_COMMIT_SHORT_SHA ?= $(.CI_COMMIT_SHORT_SHA)

.CI_COMMIT_TIMESTAMP := $(shell ${DATE} -d "@$(shell ${GIT} show -s --format=%ct)" --utc +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null)
## The timestamp of the commit in the ISO 8601 format.
CI_COMMIT_TIMESTAMP ?= $(.CI_COMMIT_TIMESTAMP)

## The full path the repository is cloned to
CI_PROJECT_DIR ?= $(PROJECT_PATH)

.CI_COMMIT_TAG := $(shell ${GIT} describe --tags --exact-match 2>/dev/null)
## The commit tag name. Can be empty if no tag corresponds to commit
CI_COMMIT_TAG ?= $(.CI_COMMIT_TAG)

## The instance-level ID of the current pipeline
CI_PIPELINE_ID ?= $(MAKE_PPID)

.CI_PIPELINE_CREATED_AT := $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")
## The UTC datetime when the pipeline was created
CI_PIPELINE_CREATED_AT ?= $(.CI_PIPELINE_CREATED_AT)

## The UTC datetime when a job started
CI_JOB_STARTED_AT ?= $(CI_PIPELINE_CREATED_AT)

## The name of the environment for this job
CI_ENVIRONMENT_NAME ?=
ifeq ($(CI_ENVIRONMENT_NAME),)
	ifneq ($(call filter-false,$(CI)),)
# Do nothing
	else
		CI_ENVIRONMENT_NAME = local
	endif
endif

## The simplified version of CI_ENVIRONMENT_NAME
CI_ENVIRONMENT_SLUG ?= $(call slugify, $(CI_ENVIRONMENT_NAME))

## The URL of the environment for this job.
CI_ENVIRONMENT_URL ?=

.GIT_REMOTE_ORIGIN_URL := $(shell ${GIT} remote get-url origin)

.CI_PROJECT_URL := $(basename $(shell echo "$(.GIT_REMOTE_ORIGIN_URL)" | sed -r 's:git@([^/]+)\:(.*):https\://\1/\2:g' ))
## The HTTP(S) address of the project.
CI_PROJECT_URL ?= $(.CI_PROJECT_URL)

.CI_PROJECT_NAME := $(basename $(notdir $(.GIT_REMOTE_ORIGIN_URL)))
## The project name
CI_PROJECT_NAME ?= $(.CI_PROJECT_NAME)

## The project namespace (username or group name).
CI_PROJECT_NAMESPACE ?= $(shell echo $(CI_PROJECT_URL) | sed -r 's|^https?://||' | cut -d '/' -f2- | xargs dirname)

## The root project namespace (username or group name).
CI_PROJECT_ROOT_NAMESPACE ?= $(shell echo $(CI_PROJECT_NAMESPACE) | cut -d '/' -f1)

## The project namespace with the project name included.
CI_PROJECT_PATH ?= $(CI_PROJECT_NAMESPACE)/$(CI_PROJECT_NAME)

.CI_RUNNER_ID := $(HOSTNAME)
## The unique ID of the runner being used
CI_RUNNER_ID ?= $(.CI_RUNNER_ID)

## The description of the runner.
CI_RUNNER_DESCRIPTION ?= $(CI_RUNNER_ID)

## The address of the GitLab Container Registry
CI_REGISTRY ?=

ifneq ($(CI_REGISTRY),)
.CI_REGISTRY_IMAGE_DEFAULT := $(CI_REGISTRY)/$(CI_PROJECT_PATH)
else
.CI_REGISTRY_IMAGE_DEFAULT := $(CI_PROJECT_PATH)
endif
# lower case by default
.CI_REGISTRY_IMAGE_DEFAULT := $(shell echo $(.CI_REGISTRY_IMAGE_DEFAULT) | tr '[:upper:]' '[:lower:]')

## The address of the project’s Container Registry
CI_REGISTRY_IMAGE ?= $(.CI_REGISTRY_IMAGE_DEFAULT)

## The username to push containers to the project’s Container Registry.
CI_REGISTRY_USER ?=

## The password to push containers to the project’s Container Registry.
CI_REGISTRY_PASSWORD ?=

## The docker image repository with the $CI_COMMIT_REF_SLUG suffix if not a release
CI_APPLICATION_REPOSITORY ?= $(if $(CI_COMMIT_TAG),$(CI_REGISTRY_IMAGE),$(CI_REGISTRY_IMAGE)/$(CI_COMMIT_REF_SLUG))

## The docker image tag
CI_APPLICATION_TAG ?= $(or $(CI_COMMIT_TAG), $(CI_COMMIT_SHA))

# Register CI_* variables
CI_VARIABLES = $(sort CI $(filter-out CI_BUILD_VERSION_TEMPLATE CI_VARIABLES %_TOKEN %_PASSWORD, $(filter CI_%,$(.VARIABLES))))

# Debug
##
# DEBUG_BIND ?= 127.0.0.1
##
# DEBUG_PORT ?= 9229

# print-%  : ; @echo "$*" = "$($*)"

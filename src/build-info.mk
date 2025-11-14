# File containing the current build number
#
# In local mode, the build number is generated when make command is executed
# In CI mode, the build number is generated at the start of pipeline
CI_BUILD_NUMBER_FILE := $(MAKE_CACHE_PATH)/build-number

## Type of build (release/debug)
CI_BUILD_TYPE ?=
ifeq ($(CI_BUILD_TYPE),)
	ifneq ($(call filter-false,$(CI)),)
		CI_BUILD_TYPE = release
	else
		CI_BUILD_TYPE = debug
	endif
endif

# Target generating the build number from current timestamp
$(CI_BUILD_NUMBER_FILE): $(MAKE_PIDFILE)
	$(Q)$(MKDIRP) $(dir $@)
	$(Q)echo "$$($(DATE) +%s)" > $@;
	@$(call log,debug,[Make] CI_BUILD_NUMBER=$(CI_BUILD_NUMBER) saved to "$@",0)

# Update .cache/make/build-number file before each job.
.before_each:: $(CI_BUILD_NUMBER_FILE)
	@:

## A unique identifier for this build, it can be used in ios, android version number
CI_BUILD_NUMBER ?= $(shell cat $(CI_BUILD_NUMBER_FILE) 2>/dev/null)

# Target that will create the current build number
# WARNING: this implementation will recreate a new build number for every new make command
# TODO: we should implement a special case for CI, that will use a previously generated file
.PHONY: build-number
build-number: $(CI_BUILD_NUMBER_FILE) ## Generate a new build number and display it in console
	@echo $(CI_BUILD_NUMBER)

## Full build version expression
CI_BUILD_VERSION_TEMPLATE ?= $(VERSION)+$(CI_COMMIT_SHORT_SHA)

# File containing the CI_BUILD_VERSION value
CI_BUILD_VERSION_FILE := $(MAKE_CACHE_PATH)/build-version

## Unique build version (ex: 1.0.0+8fe0f61)
CI_BUILD_VERSION ?= $(shell cat $(CI_BUILD_VERSION_FILE) 2>/dev/null)

# Target that will create the current build number only if needed
$(CI_BUILD_VERSION_FILE): $(CI_BUILD_NUMBER_FILE) FORCE
# Write pid file only if changed.
	$(Q)if echo "$(CI_BUILD_VERSION_TEMPLATE)" | cmp -s - $@;then \
		$(call log,debug,[Make] CI_BUILD_VERSION=$(CI_BUILD_VERSION_TEMPLATE) no changes,0); \
	else \
		echo "$(CI_BUILD_VERSION_TEMPLATE)" > $@ && \
		$(call log,debug,[Make] CI_BUILD_VERSION=$(CI_BUILD_VERSION_TEMPLATE) saved to "$@",0); \
	fi

# Update .cache/make/build-version file before each job.
.before_each:: $(CI_BUILD_VERSION_FILE)

# Target to read or create a .cache/make/build-version file containing the CI_BUILD_VERSION
#
# Example:
# 	make build-version # > 1.0.0+8fe0f61
.PHONY: build-version
build-version: $(CI_BUILD_VERSION_FILE) ## Display app build version (ex: 1.0.0+8fe0f61)
	@echo $(CI_BUILD_VERSION)

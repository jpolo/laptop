
SCALINGO := scalingo
SCALINGO_CACHE_PATH := $(PROJECT_CACHE_PATH)/scalingo
SCALINGO_ARCHIVE_FILE := $(SCALINGO_CACHE_PATH)/scalingo-app.tar.gz
## Scalingo region (default: osc-fr1)
SCALINGO_REGION ?= osc-fr1
export SCALINGO_REGION
## Scalingo default app prefix (default: $(CI_PROJECT_NAME))
SCALINGO_APP_PREFIX ?= $(CI_PROJECT_NAME)
## Scalingo default app suffix (default: -$(CI_ENVIRONMENT_SLUG))
SCALINGO_APP_SUFFIX ?= -$(CI_ENVIRONMENT_SLUG)
## Scalingo app name (default: $(SCALINGO_APP_PREFIX)$(SCALINGO_APP_SUFFIX))
SCALINGO_APP ?= $(SCALINGO_APP_PREFIX)$(SCALINGO_APP_SUFFIX)
export SCALINGO_APP

# Register variables to be displayed before deployment
DEPLOY_VARIABLES += SCALINGO_APP SCALINGO_REGION

# Fake target to setup scalingo
$(MAKE_CACHE_PATH)/job/scalingo-setup: $(MAKE_CACHE_PATH)
	$(Q)command -v scalingo >/dev/null 2>&1 || { \
		$(call log,info,"[Scalingo] Install CLI...",1); \
		if command -v brew >/dev/null 2>&1; then \
			brew install scalingo; \
		else \
			curl -O https://cli-dl.scalingo.com/install && bash install; \
		fi \
	}

#
# Install scalingo cli if not present
#
.PHONY: scalingo-setup
scalingo-setup: $(MAKE_CACHE_PATH)/job/scalingo-setup

#
# Create a tarball of the app, to be deployed in scalingo
#
.PHONY: scalingo-archive
scalingo-archive:
	@$(call log,info,"[Scalingo] Bundle $(SCALINGO_APP)...",1)
# Ensure previous temporary folder is empty
	$(Q)$(RM) -rf $(SCALINGO_ARCHIVE_FILE).tmp
# Create temporary folder containing the archive
	$(Q)$(MKDIRP) $(SCALINGO_ARCHIVE_FILE).tmp
# Create an archive folder ready to be zipped
	$(Q)$(GIT) archive --prefix=master/ HEAD | tar -x -C $(SCALINGO_ARCHIVE_FILE).tmp
# Dump environment so scalingo will be able to build the app with the same variables
	$(Q)CI=1 make print-env > $(SCALINGO_ARCHIVE_FILE).tmp/master/$(MAKEFILE_LOCAL)
# Create a zip from the temporary folder
	$(Q)tar -czf $(SCALINGO_ARCHIVE_FILE) -C $(SCALINGO_ARCHIVE_FILE).tmp master
# Remove the temporary folder
	$(Q)$(RM) -rf $(SCALINGO_ARCHIVE_FILE).tmp

#
# Clean scalingo cache (deploy archives)
#
.PHONY: scalingo-clean
scalingo-clean:
	@$(call log,info,"[Scalingo] Clean cache...",1)
	$(Q)$(RM) -rf $(SCALINGO_ARCHIVE_FILE)
	$(Q)$(RM) -rf $(SCALINGO_CACHE_PATH)
.clean:: scalingo-clean

#
# Deploy app archive to Scalingo
#
# This method is better than git push because it exits with non zero code on failure
#
.PHONY: scalingo-deploy
scalingo-deploy: scalingo-setup scalingo-archive
	@$(call log,info,"[Scalingo] Deploy $(SCALINGO_APP)...",1)
	$(Q)$(SCALINGO) --app $(SCALINGO_APP) --region=$(SCALINGO_REGION) deploy ${SCALINGO_ARCHIVE_FILE}
.deploy::scalingo-deploy

#
# Report any error to be able to run scalingo
#
.PHONY: scalingo-doctor
scalingo-doctor:
	@$(call log,info,"✓ Checking scalingo command",1);
	$(Q)command -v $(SCALINGO) >/dev/null 2>&1 || { \
		$(call log,error,scalingo command not found,2); \
		$(call log,error,Run 'make setup' to fix.,2); \
		exit 1; \
	}

MAKEFILE_DOCTOR_TARGETS += scalingo-doctor # Register as a target for make doctor task

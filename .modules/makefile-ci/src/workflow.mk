.PHONY: all
all: setup dependencies lint ## Run all targets

#-------------
# SETUP
#-------------
.PHONY: setup $(call core-hooks,.setup)
setup: setup.workflow-intro $(call core-hooks,.setup) ## Install global dependencies and setup the project

.setup.before::
	@:
.setup::
	@:
.setup.after::
	@:

#-------------
# INSTALL
#-------------
.PHONY: install $(call core-hooks,.install)
install: install.workflow-intro $(call core-hooks,.install) ## Install project dependencies (force installation)

.install.before::
	@:
.install::
	@:
.install.after::
	@:

#-------------
# DEPENDENCIES
#-------------
.PHONY: dependencies $(call core-hooks,.dependencies)
dependencies: dependencies.workflow-intro $(call core-hooks,.dependencies) ## Ensure project dependencies are present (install only if needed)

.dependencies.before::
	@:
.dependencies::
	@:
.dependencies.after::
	@:

#-------------
# BUILD
#-------------
.PHONY: build $(call core-hooks,.build)
build: build.workflow-intro $(call core-hooks,.build) ## Build sources

.build.before::
	@:
.build::
	@:
.build.after::
	@:

#-------------
# CLEAN
#-------------
.PHONY: clean $(call core-hooks,.clean)
clean: clean.workflow-intro $(call core-hooks,.clean) ## Clean build files

.clean.before::
	@:
.clean::
	@:
.clean.after::
	@:

#-------------
# LINT
#-------------
.PHONY: lint $(call core-hooks,.lint)
lint: dependencies lint.workflow-intro $(call core-hooks,.lint) ## Lint all source files

.lint.before::
	@:
.lint::
	@:
.lint.after::
	@:

#-------------
# FORMAT
#-------------
.PHONY: format $(call core-hooks,.format)
format: dependencies format.workflow-intro $(call core-hooks,.format) ## Format all source files

.format.before::
	@:
.format::
	@:
.format.after::
	@:

#-------------
# TEST
#-------------
.PHONY: test $(call core-hooks,.test)
test: dependencies test.workflow-intro $(call core-hooks,.test) ## Run unit tests

.test.before::
	@:
.test::
	@:
.test.after::
	@:

#-------------
# TEST SYSTEM (E2E)
#-------------
.PHONY: test-e2e $(call core-hooks,.test-e2e)
test-e2e: dependencies test-e2e.workflow-intro $(call core-hooks,.test-e2e) ## Run system tests (e2e)

.test-e2e.before::
	@:
.test-e2e::
	@:
.test-e2e.after::
	@:

#-------------
# DEVELOP
#-------------
.PHONY: develop $(call core-hooks,.develop)
develop: dependencies develop.workflow-intro $(call core-hooks,.develop) ## Setups a local development environment

.develop.before::
	ifneq ($(call filter-false,$(CI)),)
		@$(call log,warn,"[Develop] Job disabled in CI mode",0)
		@exit 0
	endif
.develop::
	@:
.develop.after::
	@:

#-------------
# SCAN
#-------------
#
# To add a new target to scan
#
# my-target-scan:
# 	@echo 'Scan!'
#
# MAKEFILE_SCAN_TARGETS += my-target-scan
#
.PHONY: scan $(call core-hooks,.scan)
scan: scan.workflow-intro $(call core-hooks,.scan) ## Scan code for potential issues

.scan.before::
	@:
.scan:
	$(Q)FAILS=0; \
	for target in $(MAKEFILE_SCAN_TARGETS); do \
		$(MAKE) $$target || FAILS=1; \
	done; \
	if [ $$FAILS -eq 0 ]; then \
		$(call log,info,"🎉 Everything is OK",1); \
	else \
		$(call log,fatal,"❌ Some problems need to be fixed",1); \
		exit 1; \
	fi
.scan.after::
	@:

# A list of variable names that will be displayed before deployment
DEPLOY_VARIABLES := \
	CI_ENVIRONMENT_URL

#-------------
# DEPLOY
#-------------
.PHONY: deploy $(call core-hooks,.deploy)
deploy: deploy.workflow-intro $(call core-hooks,.deploy) ## Deploy the application to the given environment

.deploy.before::
# Display important deploy variables
	$(Q)for VARIABLE in $(sort $(CI_VARIABLES) $(DEPLOY_VARIABLES)); do \
		VALUE="$$($(PRINTENV) $$VARIABLE || echo '')";\
		if [[ "$$VARIABLE" = "CI_ENVIRONMENT_NAME" && "$$VALUE" = "local" ]];then \
			$(call log,error,$$VARIABLE="$$VALUE" (forbidden value, use CI_ENVIRONMENT_NAME=<environment> make deploy),1); \
		else \
			$(call log,info,$$VARIABLE="$$VALUE",1); \
		fi; \
	done;

# Stop program if CI_ENVIRONMENT_NAME is local
ifeq ($(CI_ENVIRONMENT_NAME),local)
	@$(call panic,Deployment stopped,1);
endif

# Confirmation when CI mode
ifneq ($(call filter-false,$(CI)),)
	@:
else
	$(Q)$(call log,warn,WARNING! This will deploy local files,1)
	$(Q)read -r -p "Continue? [y/N]" REPLY;echo; \
	if [[ ! "$$REPLY" =~ ^[Yy]$$ ]]; then \
		$(call panic,Deployment stopped by user,1); \
	fi
endif

.deploy::
	@:
.deploy.after::
	@:

#-------------
# RESCUE
#-------------
.PHONY: rescue $(call core-hooks,.rescue)
rescue: rescue.workflow-intro $(call core-hooks,.rescue) ## Clean everything in case of problem

.rescue.before::
ifneq ($(call filter-false,$(CI)),)
	@$(call log,warn,"[Rescue] Job disabled in CI mode",0)
	$(Q)exit 1
endif
.rescue::
	@:
.rescue.after::
	@:

# Reinstall after rescue
.rescue.before::
	@$(call log,info,"[Git] Clean all local changes...",1)
	$(Q)$(call log,warn,WARNING! This will remove all non commited git changes.,1)
	$(Q)read -r -p "Continue? [y/N]" REPLY;echo; \
	if [[ "$$REPLY" =~ ^[Yy]$$ ]]; then \
		$(GIT) clean -fdx; \
	fi
.rescue.after:: dependencies

# This generic job allow to easily switch implementation between local and CI mode
#
# Example :
# job: job.workflow-run
# 	-> Will run job.ci when $(CI) is set
#   -> Will run job.local when $(CI) is not set
#
ifneq ($(call filter-false,$(CI)),)
%.workflow-intro:
	@$(call log,info,"[Make] $* \(mode=CI\)")
else
%.workflow-intro:
	@$(call log,info,"[Make] $* \(mode=Local\)")
endif

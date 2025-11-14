
HEROKU := heroku
HEROKU_CACHE_PATH := $(PROJECT_CACHE_PATH)/heroku

## Heroku api key used to login with cli
HEROKU_API_KEY ?=
## Heroku default app prefix (default: $(CI_PROJECT_NAME))
HEROKU_APP_PREFIX ?= $(CI_PROJECT_NAME)
## Heroku default app suffix (default: -$(CI_ENVIRONMENT_SLUG))
HEROKU_APP_SUFFIX ?= -$(CI_ENVIRONMENT_SLUG)
## Heroku app name (default: $(HEROKU_APP_PREFIX)$(HEROKU_APP_SUFFIX))
HEROKU_APP ?= $(HEROKU_APP_PREFIX)$(HEROKU_APP_SUFFIX)

# Heroku git url
ifneq ($(HEROKU_API_KEY),)
	HEROKU_GIT_URL := https://heroku:$(HEROKU_API_KEY)@git.heroku.com
else
	HEROKU_GIT_URL := https://git.heroku.com
endif

# Register variables to be displayed before deployment
DEPLOY_VARIABLES += HEROKU_APP

# Fake target to setup heroku
$(MAKE_CACHE_PATH)/job/heroku-setup: $(MAKE_CACHE_PATH)
	$(Q)command -v heroku >/dev/null 2>&1 || { \
		$(call log,info,"[Heroku] Install CLI...",1); \
		if command -v brew >/dev/null 2>&1; then \
			brew tap heroku/brew && brew install heroku; \
		else \
			curl https://cli-assets.heroku.com/install.sh | sh; \
		fi \
	}

#
# Install heroku cli if not present
#
.PHONY: heroku-setup
heroku-setup: $(MAKE_CACHE_PATH)/job/heroku-setup

#
# Login to heroku (will open a browser)
#
.PHONY: heroku-login
heroku-login: heroku-setup
ifneq ($(HEROKU_API_KEY),)
	@$(call log,info,"[Heroku] Login using \$$HEROKU_API_KEY...",1)
else
	$(Q):
endif

#
# Deploy to heroku
#
.PHONY: heroku-deploy
heroku-deploy: heroku-setup heroku-login
	@$(call log,info,"[Heroku] Deploy $(HEROKU_APP)...",1)
	$(Q)$(GIT) push --no-verify --force $(HEROKU_GIT_URL)/$(HEROKU_APP).git HEAD:main

#
# Report any error to be able to run heroku
#
.PHONY: heroku-doctor
heroku-doctor:
	@$(call log,info,"✓ Checking heroku command",1);
	$(Q)command -v $(HEROKU) >/dev/null 2>&1 || { \
		$(call log,error,heroku command not found,2); \
		$(call log,error,Run 'make setup' to fix.,2); \
		exit 1; \
	}

MAKEFILE_DOCTOR_TARGETS += heroku-doctor # Register as a target for make doctor task

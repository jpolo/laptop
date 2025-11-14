ifneq ($(wildcard .rubocop.yml),)
	RUBOCOP_ENABLED := true
endif

ifneq ($(wildcard .rubycritic.yml),)
## Enable Rubycritic (default: <detect .rubycritic.yml>)
RUBYCRITIC_ENABLED ?= true
endif

ifneq ($(wildcard rakefile Rakefile rakefile.rb Rakefile.rb),)
	RAKE_ENABLED := true
endif

## Ruby cache path (default: .cache/ruby)
RUBY_CACHE_PATH ?= $(PROJECT_CACHE_PATH)/ruby

## Ruby version manager used to install node (asdf, rbenv, ...)
RUBY_VERSION_MANAGER ?= $(call resolve-command,asdf rbenv rvm)

## Ruby version
RUBY_VERSION ?=
# Detect ruby version
ifeq ($(RUBY_VERSION),)
	ifneq ($(wildcard .tool-versions),)
		RUBY_VERSION := $(shell cat .tool-versions | grep ruby | awk '{print $$2}')
	else ifneq ($(wildcard .ruby-version),)
		RUBY_VERSION := $(shell cat .ruby-version | head -n 1 | sed -Ee 's/^ruby-([[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+)$/\1/)
	else
		RUBY_VERSION :=
	endif
endif
export RUBY_VERSION

## Bundler gem version
BUNDLER_VERSION ?= $(shell if [ -e Gemfile.lock ]; then grep "BUNDLED WITH" Gemfile.lock -A 1 | grep -v "BUNDLED WITH" | tr -d "[:space:]"; else echo ""; fi)
## Bundler gem installation path
BUNDLE_PATH ?=
ifneq ($(call filter-false,$(CI)),)
	BUNDLE_PATH ?= vendor/bundle
endif
export BUNDLE_PATH
## Bundle `install` will exit with error if Gemfile.lock is not up to date
BUNDLE_FROZEN ?=
ifneq ($(call filter-false,$(CI)),)
	BUNDLE_FROZEN ?= true
endif
export BUNDLE_FROZEN
## Bundle `install` will force platform
BUNDLE_FORCE_RUBY_PLATFORM ?=
export BUNDLE_FORCE_RUBY_PLATFORM

BUNDLE_INSTALL := ${BUNDLE} install
RUBOCOP := ${BUNDLE} exec rubocop
RAKE := ${BUNDLE} exec rake

# Create make cache directory
$(RUBY_CACHE_PATH):
	$(Q)${MKDIRP} $(RUBY_CACHE_PATH)

$(RUBY_CACHE_PATH)/ruby-version: $(RUBY_CACHE_PATH)
	$(Q)echo $(RUBY_VERSION) > $@

${BUNDLE_CACHE_PATH}:
	@[ ! -z "${BUNDLE_CACHE_PATH}" ] && ${MKDIRP} "${BUNDLE_CACHE_PATH}"

${BUNDLE_PATH}: ${BUNDLE_CACHE_PATH}
	@[ ! -z "${BUNDLE_PATH}" ] && ${MKDIRP} "${BUNDLE_PATH}"

#
# Setup Ruby
#
# This will install Ruby using $(RUBY_VERSION_MANAGER)
#
.PHONY: ruby-setup
ruby-setup: $(RUBY_CACHE_PATH)/ruby-version

# Try installing node using $(RUBY_VERSION_MANAGER)
ifeq ($(RUBY_VERSION),)
	@$(call log,warn,"[Ruby] Cannot install ruby. Please set RUBY_VERSION or configure .tools-versions",1)
else ifneq ($(shell ruby -v 2>/dev/null | awk '{ print $$2 }'),$(RUBY_VERSION))
	@$(call log,info,"[Ruby] Install Ruby with $(RUBY_VERSION_MANAGER)...",1)
ifeq ($(RUBY_VERSION_MANAGER),asdf)
	$(Q)$(ASDF) plugin add ruby
	$(Q)$(ASDF) install ruby $(RUBY_VERSION)
else ifeq ($(RUBY_VERSION_MANAGER),rvm)
	$(Q)rvm install $(RUBY_VERSION)
	$(Q)rvm use $(RUBY_VERSION) --default
else
	@$(call panic,[Ruby] Unsupported ruby version manager $(RUBY_VERSION_MANAGER))
endif

# Configure bundle local project
	$(Q)if [ -z "$(BUNDLE_PATH)" ]; then \
		${BUNDLE} config unset --local path; \
	else \
		${BUNDLE} config set --local path $(BUNDLE_PATH); \
	fi
endif
.setup:: ruby-setup # Add to `make setup`

#
# Install ruby gem dependencies (bundle install) only if needed
#
.PHONY: ruby-dependencies
ruby-dependencies: ruby-setup
  # Test if
	$(Q)if ! ${BUNDLE} check --dry-run > /dev/null 2>&1; then \
		$(call log,info,"[Ruby] Ensure dependencies....",1); \
		$(Q)${BUNDLE_INSTALL}; \
	fi
.dependencies:: ruby-dependencies

#
# Force install ruby gem dependencies (bundle install)
#
.PHONY: ruby-install
ruby-install: ruby-setup
	@$(call log,info,"[Ruby] Install dependencies....",1)
	$(Q)${BUNDLE_INSTALL}
.install:: ruby-install # Add `bundle install` to `make install`

# Rubocop targets
ifneq ($(call filter-false,$(RUBOCOP_ENABLED)),)

#
# Lint ruby source code (using rubocop)
#
.PHONY: ruby-lint
ruby-lint: ruby-dependencies
	@$(call log,info,"[Ruby] Lint sources...",1)
	$(Q)${RUBOCOP}
.lint:: ruby-lint # Add rubocop to `make lint`

#
# Format ruby source code (using rubocop)
#
.PHONY: ruby-format
ruby-format: ruby-dependencies
	@$(call log,info,"[Ruby] Format sources...",1)
	$(Q)${RUBOCOP} -a
.format:: ruby-format # Add rubocop to `make format`

endif

# RubyCritic targets
ifneq ($(call filter-false,$(RUBYCRITIC_ENABLED)),)
RUBYCRITIC := $(BUNDLE) exec rubycritic
RUBYCRITIC_FLAGS :=

## RubyCritic format (html/json/console, default: console)
RUBYCRITIC_FORMAT ?= console

## RubyCritic branch (i.e. main)
RUBYCRITIC_BRANCH ?= $(CI_DEFAULT_BRANCH)

ifneq ($(call filter-false,$(CI)),)
	RUBYCRITIC_FLAGS += --mode-ci
endif

#
# Audit code using RubyCritic
#
.PHONY: ruby-critic
ruby-critic: ruby-dependencies
ifneq ($(CI_DEFAULT_BRANCH), $(CI_COMMIT_BRANCH))
	@$(call log,info,"[Ruby] RubyCritic...",1)
#	$(Q)$(GIT) fetch origin $(CI_DEFAULT_BRANCH):$(CI_DEFAULT_BRANCH)
	$(Q)$(RUBYCRITIC) \
		--branch $(CI_DEFAULT_BRANCH) \
		--format $(RUBYCRITIC_FORMAT) \
		$(RUBYCRITIC_FLAGS)
else
	@$(call log,warn,"[Ruby] Rubycritic skipped \(current is default branch\).",1)
endif

MAKEFILE_SCAN_TARGETS += ruby-critic
endif

#
# Run unit tests
#
.PHONY: ruby-test
ruby-test: ruby-dependencies
ifneq ($(call filter-false,$(RAKE_ENABLED)),)
	@$(call log,info,"[Ruby] Test ...",1)
	$(Q)$(RAKE) db:migrate || echo "Warning: Migration failed"
	$(Q)$(RAKE) spec
else
	@$(call log,warn,"[Ruby] Test skipped",1)
endif
.test:: ruby-test # Add rspec to `make test`

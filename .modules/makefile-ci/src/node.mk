ifeq ($(COREPACK_ENABLE_DOWNLOAD_PROMPT),)
export COREPACK_ENABLE_DOWNLOAD_PROMPT := 0
endif

## NodeJS cache path (default: .cache/node)
NODEJS_CACHE_PATH ?= $(PROJECT_CACHE_PATH)/node

## NodeJS version manager used to install node (asdf, nvm, ...)
NODEJS_VERSION_MANAGER ?=

## NodeJS package manager (npm,pnpm,yarn,yarn-berry,bun)
NODEJS_PACKAGE_MANAGER ?=
# Detect nodejs package manager
ifeq ($(NODEJS_PACKAGE_MANAGER),)
	ifneq ($(wildcard yarn.lock),)
		ifneq ($(wildcard .yarnrc.yml),)
			NODEJS_PACKAGE_MANAGER := yarn-berry
			NODEJS_PACKAGE_MANAGER_COMMAND := yarn
		else
			NODEJS_PACKAGE_MANAGER := yarn
			NODEJS_PACKAGE_MANAGER_COMMAND := yarn
		endif
	else ifneq ($(wildcard pnpm-lock.yaml),)
		NODEJS_PACKAGE_MANAGER := pnpm
		NODEJS_PACKAGE_MANAGER_COMMAND := pnpm
	else ifneq ($(wildcard bun.lock bun.lockb),)
		NODEJS_PACKAGE_MANAGER := bun
		NODEJS_PACKAGE_MANAGER_COMMAND := bun
	else
		NODEJS_PACKAGE_MANAGER := npm
		NODEJS_PACKAGE_MANAGER_COMMAND := npm
	endif
endif

# Corepack enable command
ifeq ($(NODEJS_VERSION_MANAGER),asdf)
	.NODEJS_INSTALL_PACKAGE_MANAGER_COMMAND = corepack enable && asdf reshim nodejs
else
	.NODEJS_INSTALL_PACKAGE_MANAGER_COMMAND = corepack enable
endif

## NodeJS version
NODEJS_VERSION ?=
# Detect nodejs version
ifeq ($(NODEJS_VERSION),)
	ifneq ($(wildcard .tool-versions),)
		NODEJS_VERSION := $(shell cat .tool-versions | grep nodejs | awk '{print $$2}')
	else ifneq ($(wildcard .node-version),)
		NODEJS_VERSION := $(shell cat .node-version)
	else ifneq ($(wildcard .nvmrc),)
		NODEJS_VERSION := $(shell cat .nvmrc)
	endif
endif
export NODEJS_VERSION

## NodeJS install frozen (default: true in CI mode, false else)
NODEJS_FROZEN ?=
ifeq ($(NODEJS_FROZEN),)
	ifneq ($(call filter-false,$(CI)),)
		NODEJS_FROZEN := true
	else
		NODEJS_FROZEN := false
	endif
endif

#
# Define package manager settings
#
ifeq ($(NODEJS_PACKAGE_MANAGER),yarn-berry)
# Yarn berry
	NODEJS_RUN := yarn run
# Lockfile
	NODEJS_LOCKFILE := yarn.lock
# State file
	NODEJS_STATEFILE := node_modules/.yarn-state.yml
# Yarn berry frozen mode
	ifneq ($(call filter-false,$(NODEJS_FROZEN)),)
		NODEJS_INSTALL := yarn install --immutable
	else
		NODEJS_INSTALL := yarn install
	endif
else ifeq ($(NODEJS_PACKAGE_MANAGER),yarn)
# Yarn
	NODEJS_RUN := yarn run
# Lockfile
	NODEJS_LOCKFILE := yarn.lock
# State file
	NODEJS_STATEFILE := node_modules/.yarn-state.yml
# Yarn frozen mode
	ifneq ($(call filter-false,$(NODEJS_FROZEN)),)
		NODEJS_INSTALL := yarn install --frozen-file
	else
		NODEJS_INSTALL := yarn install
	endif
else ifeq ($(NODEJS_PACKAGE_MANAGER),pnpm)
# PNPM
	NODEJS_RUN := pnpm run
# Lockfile
	NODEJS_LOCKFILE := pnpm-lock.yaml
# State file
	NODEJS_STATEFILE := node_modules/.modules.yaml
# PNPM frozen mode
	ifneq ($(call filter-false,$(NODEJS_FROZEN)),)
		NODEJS_INSTALL := pnpm install --frozen-lockfile
	else
		NODEJS_INSTALL := pnpm install --no-frozen-lockfile
	endif
export PNPM_CONFIG_CACHE
else ifeq ($(NODEJS_PACKAGE_MANAGER),bun)
# Bun
	NODEJS_RUN := bun run
# Lockfile
	NODEJS_LOCKFILE := bun.lock bun.lockb
# State file
	NODEJS_STATEFILE := node_modules/.bun.lock
# Bun frozen mode
	ifneq ($(call filter-false,$(NODEJS_FROZEN)),)
		NODEJS_INSTALL := bun install --frozen-lockfile
	else
		NODEJS_INSTALL := bun install
	endif
else
# NPM should be used
	NODEJS_RUN := npm run
# Lockfile
	NODEJS_LOCKFILE := package-lock.json
# State file
	NODEJS_STATEFILE := node_modules/.package-lock.json
# NPM frozen mode
	ifneq ($(call filter-false,$(NODEJS_FROZEN)),)
		NODEJS_INSTALL := npm ci
	else
		NODEJS_INSTALL := npm install
	endif
export NPM_CONFIG_CACHE
endif

# Create make cache directory
$(NODEJS_CACHE_PATH):
	$(Q)${MKDIRP} $(NODEJS_CACHE_PATH)

# A file that contains node required version
$(NODEJS_CACHE_PATH)/node-version: $(NODEJS_CACHE_PATH)
	$(Q)echo $(NODEJS_VERSION) > $@

# A target that will run node install only if lockfile was changed
NODEJS_PACKAGE_JSON_FILES := $(shell find . -name package.json -not -path '**/node_modules/*' -not -path './.git/*')

$(NODEJS_STATEFILE): $(wildcard $(NODEJS_LOCKFILE)) $(NODEJS_PACKAGE_JSON_FILES)
# Try installing package manager
ifeq ($(filter npm,$(NODEJS_PACKAGE_MANAGER)),)
# Only for asdf we have to reshim after corepack
	$(Q)if ! $(NODEJS_PACKAGE_MANAGER_COMMAND) -v &>/dev/null; then \
		$(call log,info,"[NodeJS] Install $(NODEJS_PACKAGE_MANAGER)...",1); \
		$(.NODEJS_INSTALL_PACKAGE_MANAGER_COMMAND); \
	fi
endif
	@$(call log,info,"[NodeJS] Ensure dependencies....",1)
	$(Q)${NODEJS_INSTALL}
	$(Q)${TOUCH} $@

#
# Install dependencies only if needed
#
.PHONY: node-dependencies
node-dependencies: node-setup $(NODEJS_STATEFILE)
.dependencies:: node-dependencies

#
# Setup node
#
# This will install node and the configured package manager
#
.PHONY: node-setup
node-setup: $(NODEJS_CACHE_PATH)/node-version

# Try installing node using $(NODEJS_VERSION_MANAGER)
ifeq ($(NODEJS_VERSION),)
	@$(call log,warn,"[NodeJS] Cannot install nodejs. Please set NODEJS_VERSION or configure .tools-versions",1)
else ifneq ($(shell node -v 2>/dev/null),v$(NODEJS_VERSION))

ifeq ($(NODEJS_VERSION_MANAGER),)
		@$(call log,warn,"[NodeJS] NODEJS_VERSION_MANAGER is not set.",1)
else
		@$(call log,info,"[NodeJS] Install NodeJS with $(NODEJS_VERSION_MANAGER)...",1)

ifeq ($(NODEJS_VERSION_MANAGER),asdf)
			$(Q)$(ASDF) plugin add nodejs
			$(Q)$(ASDF) install nodejs $(NODEJS_VERSION)
else
			@$(call log,info,"[NodeJS] Install NodeJS with $(NODEJS_VERSION_MANAGER)...",1)
endif

endif

endif

# Try installing package manager
ifneq ($(filter $(NODEJS_PACKAGE_MANAGER),npm),)
# Only for asdf we have to reshim after corepack
	$(Q)if ! $(NODEJS_PACKAGE_MANAGER_COMMAND) -v &>/dev/null; then \
	  $(call log,info,"[NodeJS] Install $(NODEJS_PACKAGE_MANAGER)...",1); \
		$(.NODEJS_INSTALL_PACKAGE_MANAGER_COMMAND); \
	fi
endif
.setup:: node-setup # Add to `make setup`

#
# Run npm lint script (ex: npm run lint)
#
.PHONY: node-lint
node-lint: node-dependencies
	@$(call log,info,"[NodeJS] Lint sources...",1)
	$(Q)$(NODEJS_RUN) lint
.lint::	node-lint # Add `npm run lint` to `make lint`

#
# Run npm format script (ex: npm run format)
#
.PHONY: node-format
node-format: node-dependencies
	@$(call log,info,"[NodeJS] Format sources...",1)
	$(Q)$(NODEJS_RUN) format
.format:: node-format # Add `npm run test` to `make test`

#
# Run npm build script (ex: npm run build)
#
.PHONY: node-build
node-build: node-dependencies
	@$(call log,info,"[NodeJS] Build sources...",1)
	$(Q)$(NODEJS_RUN) build
.build:: node-build # Add `npm run build` to `make build`

#
# Run npm test script (ex: npm run test)
#
.PHONY: node-test
node-test: node-dependencies
	@$(call log,info,"[NodeJS] Test sources...",1);
	$(Q)$(NODEJS_RUN) test
.test:: node-test # Add npm test to `make test`

#
# Run npm test End to End script (ex: npm run test:e2e)
#
.PHONY: node-test-e2e
node-test-e2e: node-dependencies
	@$(call log,info,"[NodeJS] Test system...",1)
	$(Q)$(NODEJS_RUN) test:e2e
.test-e2e:: node-test-e2e # Add rspec to `make test-e2e`

#
# Run npm clean script (ex: npm run clean)
#
.PHONY: node-clean
node-clean: node-dependencies
	@$(call log,info,"[NodeJS] Clean files...",1);
	$(Q)$(NODEJS_RUN) clean
.clean:: node-clean # Add npm run clean to `make clean`

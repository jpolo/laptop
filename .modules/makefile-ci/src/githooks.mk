## Git hooks directory (pre-commit, pre-push, etc)
GIT_HOOKS_PATH ?= .githooks

# Create githooks path
${GIT_HOOKS_PATH}/.keep:
	$(Q)${MKDIRP} ${GIT_HOOKS_PATH}
	$(Q)${TOUCH} ${GIT_HOOKS_PATH}/.keep

#
# Configure git hooks to $(GIT_HOOKS_PATH) (.githooks/)
#
.PHONY: githooks-install
githooks-install: ${GIT_HOOKS_PATH}/.keep
ifneq ($(shell ${GIT} config core.hooksPath), $(GIT_HOOKS_PATH))
	@$(call log,info,"[Git] Install hooks...",1)
	$(Q)${GIT} config core.hooksPath ${GIT_HOOKS_PATH}
endif

.setup:: githooks-install # Install githooks during `make setup`

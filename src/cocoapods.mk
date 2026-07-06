POD := bundle exec pod
POD_FILE ?= ios/Podfile
POD_LOCKFILE ?= $(POD_FILE).lock
POD_MANIFEST := $(dir $(POD_FILE))/Pods/Manifest.lock
POD_INSTALL := cd $(dir $(POD_FILE)) && $(POD) install --repo-update

#
# Install pod executable using bundle
#
.PHONY: pod-setup
pod-setup: $(wildcard ruby-dependencies)

$(POD_MANIFEST): $(POD_LOCKFILE)
	@$(call log,info,"[Pod] Ensure dependencies....",1)
	$(Q)$(POD_INSTALL)
	$(Q)touch $(POD_MANIFEST)

#
# Install Pod dependencies only if needed
#
.PHONY: pod-dependencies
pod-dependencies: pod-setup $(POD_MANIFEST)
.dependencies:: pod-dependencies

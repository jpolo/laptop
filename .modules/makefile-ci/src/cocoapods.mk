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

#
# Force install Pod dependencies
#
# If present node dependencies will be installed before (useful for react-native, ionic, etc)
#
.PHONY: pod-install
pod-install: pod-setup $(wildcard node-dependencies)
	@$(call log,info,"[Pod] Install dependencies...",1)
	$(Q)$(POD_INSTALL)
.install:: pod-install	# Add `pod install` to `make install`

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

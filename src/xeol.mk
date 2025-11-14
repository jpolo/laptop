# @see https://github.com/xeol-io/xeol
XEOL := xeol

## Xeol name for the target
XEOL_NAME ?= $(CI_PROJECT_PATH)

# Fake target to setup xeol
$(MAKE_CACHE_PATH)/job/xeol-setup: $(MAKE_CACHE_PATH)
	$(Q)command -v xeol >/dev/null 2>&1 || { \
		$(call log,info,"[Xeol] Install CLI...",1); \
		if command -v brew >/dev/null 2>&1; then \
			brew tap xeol-io/xeol && \
			brew install xeol; \
		else \
			curl -sSfL https://raw.githubusercontent.com/xeol-io/xeol/main/install.sh | sh -s -- -b /usr/local/bin; \
		fi \
	}

#
# Install xeol cli if not present
#
.PHONY: xeol-setup
xeol-setup: $(MAKE_CACHE_PATH)/job/xeol-setup

#
# Scan sources with xeol
#
.PHONY: xeol-scan
xeol-scan: xeol-setup
	@$(call log,info,"[Xeol] Scanning sources...",1)
	$(Q)$(XEOL) "dir:." --quiet --output=table --name=$(XEOL_NAME) --fail-on-eol-found

MAKEFILE_SCAN_TARGETS += xeol-scan # Register as a target for make scan task

#
# Report any error to be able to run xeol scan
#
.PHONY: xeol-doctor
xeol-doctor:
	@$(call log,info,"✓ Checking xeol command",1);
	$(Q)command -v xeol >/dev/null 2>&1 || { \
		$(call log,error,xeol command not found,2); \
		$(call log,error,Run 'make setup' to fix.,2); \
		exit 1; \
	}

MAKEFILE_DOCTOR_TARGETS += xeol-doctor # Register as a target for make doctor task

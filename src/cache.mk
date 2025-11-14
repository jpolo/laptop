## Make cache path (default: .cache/make)
MAKE_CACHE_PATH ?= $(PROJECT_CACHE_PATH)/make

# Create make cache directory
$(MAKE_CACHE_PATH):
	@${MKDIRP} $(MAKE_CACHE_PATH)

# make should not remove these files
.PRECIOUS: $(MAKE_CACHE_PATH)/%

.PHONY: .cache-clean
.cache-clean:
	@$(call log,info,"[Make] Clean cache...",1)
	$(Q)$(RM) -rf $(MAKE_CACHE_PATH)

# Add clear cache to `make clean` target
.clean:: .cache-clean

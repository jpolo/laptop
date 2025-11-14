# Path to the file containing pid
MAKE_PIDFILE := $(MAKE_CACHE_PATH)/pid

# Add this target as dependency of another target to regenerate only when new make command
#
# Example
# my-target: $(MAKE_PIDFILE)
#   <- This will be executed only on new command
#
$(MAKE_PIDFILE): FORCE
# Write pid file only if changed.
	$(Q)echo "$(MAKE_PPID)" | cmp -s - $@ || \
		($(MKDIRP) $(dir $@) && echo "$(MAKE_PPID)" > $@ && \
			$(call log,debug,[Make] MAKE_PID=$(MAKE_PPID) saved to "$@",0) \
		)

# Create or update make pid file before each job.
# This will ensure that the file exists before each job
.before_each:: $(MAKE_PIDFILE)
	@:

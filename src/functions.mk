# Display a password with **** + last 4 characters
#
# @example
#  echo $(call mask-password,$(PASSWORD))
#
define mask-password
$(shell [ -z '$(1)' ] && (echo '') || (echo "****$(shell echo $(1) | tail -c 4)"))
endef

# Memoize an expensive value so it is computed at most once per make run.
#
# On first expansion the value is computed and the variable is rebound to a
# simple (:=) value, replacing the recursive definition. Subsequent expansions
# just return the cached string.
#
# This matters for variables that make exports: make re-expands every exported
# recursive variable each time it builds the environment for a recipe, so an
# un-memoized `$(shell ...)` would run once per recipe of every target. Memoizing
# collapses that back to a single call while keeping the value lazy (nothing runs
# at parse time or for targets that never spawn a recipe, e.g. `make -q`).
#
# The variable MUST be defined recursively (with `=`) and pass its own name:
#
#   .CI_COMMIT_SHA = $(call memoize,.CI_COMMIT_SHA,$(shell $(GIT) rev-parse HEAD))
#
# Note: top-level commas in the value expression are treated as $(call) argument
# separators. Commas inside a nested $(...) (e.g. $(call slugify,$(x))) are safe;
# otherwise wrap comma-bearing logic in its own variable and memoize that.
memoize = $(eval $1 := $2)$2

# Fallback if log is not defined
#
# @example
# $(call log,info,Message,0)
#
ifeq ($(log),)
define log
echo [$(1)] $(2)
endef
endif


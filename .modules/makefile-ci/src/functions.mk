# Display a password with **** + last 4 characters
#
# @example
#  echo $(call mask-password,$(PASSWORD))
#
define mask-password
$(shell [ -z '$(1)' ] && (echo '') || (echo "****$(shell echo $(1) | tail -c 4)"))
endef

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


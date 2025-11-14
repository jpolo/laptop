ifneq ($(DOTENV_ENABLED),)

DOTENV_FILE := .env
DOTENV_VAULT_FILE := .env.vault
## DotEnv decryption key
DOTENV_KEY ?=

# Load $(PROJECT_PATH)/.env if exists
# ifneq (,$(wildcard $(PROJECT_PATH)/$(DOTENV_FILE)))
# include $(PROJECT_PATH)/$(DOTENV_FILE)
# export
# endif

endif

.circleci/config.yml: $(MAKEFILE_CI_TEMPLATE)/.circleci/config.yml.template
	$(Q)$(MKDIRP) $(dir $@)
	$(Q)cp -f $< $@

.docker/compose-common.yaml: $(MAKEFILE_CI_TEMPLATE)/.docker/compose-common.yaml.template
	$(Q)$(MKDIRP) $(dir $@)
	$(Q)cp -f $< $@

.docker: .docker/compose-common.yaml

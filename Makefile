
.PHONY: help login build push

# Begin Help snippet
# Source: https://gist.github.com/prwhite/8168133#gistcomment-1727513
#COLORS
GREEN  := $(shell tput -Txterm setaf 2)
WHITE  := $(shell tput -Txterm setaf 7)
YELLOW := $(shell tput -Txterm setaf 3)
RESET  := $(shell tput -Txterm sgr0)

# Add the following 'help' target to your Makefile
# And add help text after each target name starting with '\#\#'
# A category can be added with @category
HELP_FUN = \
    %help; \
    while(<>) { push @{$$help{$$2 // 'options'}}, [$$1, $$3] if /^([a-zA-Z\-]+)\s*:.*\#\#(?:@([a-zA-Z\-]+))?\s(.*)$$/ }; \
    print "usage: make [target]\n\n"; \
    for (sort keys %help) { \
    print "${WHITE}$$_:${RESET}\n"; \
    for (@{$$help{$$_}}) { \
    $$sep = " " x (32 - length $$_->[0]); \
    print "  ${YELLOW}$$_->[0]${RESET}$$sep${GREEN}$$_->[1]${RESET}\n"; \
    }; \
    print "\n"; }
# End Help snippet

help: ##@general Show this help.
	@perl -e '$(HELP_FUN)' $(MAKEFILE_LIST)
	@echo ""

# Registry commands
login: ##@deploy Authenticate to getfinancing docker registry.
	#eval $(shell aws --profile ${AWS_PROFILE} ecr get-login --no-include-email --region us-east-1)
	docker login

build: ##@build Build image
	docker build . -t getfinancingdockerhub/autossh:latest

build-nc: ##@build Build image without cache
	docker build --no-cache . -t getfinancingdockerhub/autossh:latest

push: ##@deploy Push getfinancing/${PREFIX}/${TARGET} images to getfinancing docker registry within aws
	docker push getfinancingdockerhub/autossh:latest

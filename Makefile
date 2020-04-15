ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
SHELL := /bin/bash

-include .env

## create-stack: creates de specified stack in AWS. Usage is "make STACK=dirname create-stack"
create-stack:
	@echo "> Creating stack..."
	cd $(ROOT_DIR)/$(STACK) && \
	aws --profile $(AWS_PROFILE) cloudformation create-stack --stack-name "$(AWS_PREFIX)-$(AWS_ENVIRONMENT)-$(STACK)" \
        --template-body file:///$(ROOT_DIR)/$(STACK)/template.yml \
		--capabilities CAPABILITY_NAMED_IAM \
		--parameters ParameterKey=ResourcePrefix,ParameterValue=$(AWS_PREFIX) \
		             ParameterKey=ResourceEnvironment,ParameterValue=$(AWS_ENVIRONMENT)

## delete-stack: deltes the stack and its components. Usage is "make STACK=dirname create-stack"
delete-stack:
	@echo "> Deleting stack..."
	cd $(ROOT_DIR)/$(STACK) && \
	aws --profile $(AWS_PROFILE) cloudformation delete-stack --stack-name "$(AWS_PREFIX)-$(AWS_ENVIRONMENT)-$(STACK)"

.PHONY: help
all: help
help: Makefile
	@echo
	@echo " Choose a command run:"
	@echo
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'
	@echo
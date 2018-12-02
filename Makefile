.PHONY: dev prod cleandev cleanprod compile release publish docs test run

MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
APP_NAME := $(notdir $(patsubst %/,%,$(dir $(MKFILE_PATH))))
VERSION_FILE := $(dir $(MKFILE_PATH))/VERSION
VERSION := $(shell sed 's/^ *//;s/ *$$//' $(VERSION_FILE))
LOG_PREFIX = '${APP_NAME} | ${MIX_ENV}:'

GIT_HASH := $(shell git rev-parse --short HEAD)
IMAGE := $(APP_NAME):$(VERSION)-$(GIT_HASH)
LATEST := $(APP_NAME):latest
HUBTAG_VERSION := zsolt001/$(APP_NAME):$(VERSION)
HUBTAG_UNIQUE := zsolt001/$(IMAGE)
HUBTAG_LATEST := zsolt001/$(LATEST)

dev: export MIX_ENV = dev
dev: compile
	@echo MAKE DONE: $@

prod: export MIX_ENV = prod
prod: git-status-test cleanprod compile
	@echo MAKE DONE: $@

compile:
	@echo ${LOG_PREFIX} getting deps
	@mix deps.get 1>/dev/null
	@echo ${LOG_PREFIX} compiling deps
	@mix deps.compile 1>/dev/null
	@echo ${LOG_PREFIX} compiling application
	@mix compile 
	@echo MAKE DONE: $@

cleandev: export MIX_ENV = dev
cleandev:
	@echo ${LOG_PREFIX} cleaning
	@rm -rf _build/dev deps
	@echo MAKE DONE: $@

cleanprod: export MIX_ENV = prod
cleanprod:
	@echo ${LOG_PREFIX} cleaning
	@rm -rf _build/prod deps
	@echo MAKE DONE: $@

release: export MIX_ENV = prod
release: prod
	@echo ${LOG_PREFIX} creating release
	@mix release --env=prod
	@echo MAKE DONE: $@

docker.build: git-status-test
	@echo ${LOG_PREFIX} building image $(IMAGE)
	@docker build -t $(IMAGE) -f Dockerfile.x86
	@docker tag $(IMAGE) $(LATEST)
	@echo $(LOG_PREFIX) $@ DONE

docker.publish: docker.build
	@echo ${LOG_PREFIX} tagging with $(HUBTAG_VERSION)
	@docker tag $(IMAGE) $(HUBTAG_UNIQUE)
	@docker tag $(IMAGE) $(HUBTAG_VERSION)
	@docker tag $(IMAGE) $(HUBTAG_LATEST)
	@echo ${LOG_PREFIX} pushing to Docker Hub
	docker push $(HUBTAG_UNIQUE)
	docker push $(HUBTAG_VERSION)
	docker push $(HUBTAG_LATEST)
	@echo $(LOG_PREFIX) $@ DONE

docs: git-status-test
	@echo ${LOG_PREFIX} updating documentation
	@mix docs 1>/dev/null
	@echo MAKE DONE: $@

run:
	iex -S mix

test:
	@echo ${LOG_PREFIX} running tests
	@mix test
	@echo MAKE DONE: $@

git-status-test:
	@test -z "$(shell git status -s 2>&1)" \
          && echo "Git repo is clean" \
          || (echo "Failed: uncommitted changes in git repo" && exit 1)


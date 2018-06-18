ORG=khanlab
NAME=neuroglia-dwi
VERSION = v1.3.2

DOCKER_NAME=$(ORG)/$(NAME):$(VERSION)
DOCKER_LATEST=$(ORG)/$(NAME):latest
SINGULARITY_NAME=$(ORG)_$(NAME)_$(VERSION)

BUILD_DIR=~/singularity
REMOTE_BUILD_DIR=~/graham/singularity
LOCAL_UUID=9bc03c00-89ae-11e7-a97f-22000a92523b
GRAHAM_SINGULARITY_UUID=42df491c-52e1-11e8-9060-0a6d4e044368

LOG_DIR=build_logs

fromlocal:
	rm -f $(BUILD_DIR)/$(SINGULARITY_NAME).img
	sudo singularity build $(BUILD_DIR)/$(SINGULARITY_NAME).img local.Singularity.$(VERSION) | tee $(LOG_DIR)/build_$(SINGULARITY_NAME).log
	globus transfer $(LOCAL_UUID):$(BUILD_DIR)/$(SINGULARITY_NAME).img $(GRAHAM_SINGULARITY_UUID):bids-apps/$(SINGULARITY_NAME).img



build:
	rm -f $(BUILD_DIR)/$(SINGULARITY_NAME).img
	sudo singularity build $(BUILD_DIR)/$(SINGULARITY_NAME).img Singularity.$(VERSION) | tee build_$(SINGULARITY_NAME).log
	globus transfer $(LOCAL_UUID):$(BUILD_DIR)/$(SINGULARITY_NAME).img $(GRAHAM_SINGULARITY_UUID):bids-apps/$(SINGULARITY_NAME).img


sandbox:
	sudo singularity build --sandbox sandbox_$(SINGULARITY_NAME) Singularity | tee -a sandbox_$(SINGULARITY_NAME).log

	
docker_build: 
	docker build -t $(DOCKER_NAME) --rm .


docker_tag_latest:
	docker tag $(DOCKER_NAME) $(DOCKER_LATEST)

docker_push:
	docker push $(DOCKER_NAME)

docker_push_latest:
	docker push $(DOCKER_LATEST)

docker_run:
	docker run --rm -it $(DOCKER_NAME) /bin/bash	

docker_last_built_date:
	docker inspect -f '{{ .Created }}' $(DOCKER_NAME)


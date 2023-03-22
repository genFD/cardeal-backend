#############################################
# VARIABLES
PROJECT_NAME=cardeal-api
PROJECT_ID=iron-foundry-380217
TF_ACTION?=plan
ZONE=us-central1-c
USER=hk.dev
VM_NAME=cardeal-test-vm
SSH_STRING=${USER}@${VM_NAME}-${ENV}
GITHUB_SHA?=latest
LOCAL_TAG=cardeal-test:${GITHUB_SHA}
REMOTE_TAG=ecr_repo_url/${PROJECT_ID}/${LOCAL_TAG}
CONTAINER_NAME=cardeal-test-api
#############################################
# UTILS
check-env:
ifndef ENV
	$(error Please set ENV=[dev|prod])
endif 

define get-secret
$(shell gcloud secrets versions access latest --secret=$(1) --project=$(PROJECT_ID))
endef


#############################################
# DOCKER-LOCAL
run:
	docker compose up -d
shutdown:
	docker compose down
rebuild:
	docker compose up -d --build 

#############################################
# TERRAFORM

terraform-check-workspace:
	cd terraform/applications/${PROJECT_NAME} && \
		terraform workspace list

terraform-format:
	@cd terraform/applications/${PROJECT_NAME} && \
		terraform fmt && \
		cd modules/web-app && \
		terraform fmt
	
terraform-validate:
	@cd terraform/applications/${PROJECT_NAME} && \
		terraform validate && \
		cd modules/web-app && \
		terraform validate
	

terraform-switch-workspace:check-env
	@cd terraform/applications/${PROJECT_NAME} && \
		terraform workspace select ${ENV}

terraform-create-workspace:check-env
	@cd terraform/applications/${PROJECT_NAME} && \
		terraform workspace new ${ENV}

terraform-init:check-env
	cd terraform/applications/${PROJECT_NAME} && \
		terraform workspace select ${ENV} && \
		terraform init \
	
# terraform-action:check-env

#		-backend-config="bucket=${ENV}-${PROJECT_NAME}-tf-state" \
			-backend-config="dynamodb_table=${ENV}-${PROJECT_NAME}-tf-state-locking" \
# 	@cd terraform && \
# 		terraform workspace select ${ENV} && \
# 		terraform ${TF_ACTION} -var-file='./environments/common.tfvars' \
# 																									-var-file='./environments/${ENV}/config.tfvars' \
# 																									-var='cloudflare_api_token=${call get-secret,cloudflare_api_token}' \

terraform-action:check-env
	@cd terraform/applications/${PROJECT_NAME} && \
		terraform ${TF_ACTION}

#############################################
# SSH
ssh:check-env
	gcloud compute ssh ${SSH_STRING} \
				--project=${PROJECT_ID} \
				--zone=${ZONE}

ssh-cmd:check-env
	@gcloud compute ssh ${SSH_STRING} \
				--project=${PROJECT_ID} \
				--zone=${ZONE} \
				--command='${CMD}'

#############################################
# DOCKER REMOTE
build:check-env
		docker build -t ${LOCAL_TAG} .

push:check-env
		docker tag ${LOCAL_TAG} ${REMOTE_TAG}
		docker push ${REMOTE_TAG}

deploy:check-env
	${MAKE} ssh-cmd CMD='docker-credential-gcr configure-docker'
	@echo "pulling new container image..."
	${MAKE} ssh-cmd CMD='docker pull ${REMOTE_TAG}'
	@echo "removing old container..."
	-${MAKE} ssh-cmd CMD='docker container stop ${CONTAINER_NAME}'
	-${MAKE} ssh-cmd CMD='docker container rm ${CONTAINER_NAME}'
	@echo "Starting new container..."
	@${MAKE} ssh-cmd CMD='\
				docker run -d --name=${CONTAINER_NAME} \
						--restart=unless-stopped \
						-p 80:3000 \
						-e PORT=3000  \
						-e \"DATABASE_URL=postgresql://postgres:p1R4ViebzOg20MJMMYLx@containers-us-west-203.railway.app:6382/railway\" \
						${REMOTE_TAG} \
	'
# nestgcpvm-staging.fsgig.com
# -e \"DATABASE_URL=postgresql://postgres:p1R4ViebzOg20MJMMYLx@containers-us-west-203.railway.app:6382/railway\" \
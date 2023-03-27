#############################################
# VARIABLES
PROJECT_NAME=cardeal-api
ACCOUNT_ID=302671405705
TF_ACTION?=plan
REGION=us-east-1
USER=ec2-user
KEY_PAIR = ~/.ssh/aws_001
VM_HOST=ec2-54-227-127-141.compute-1.amazonaws.com
GITHUB_SHA?=latest
LOCAL_TAG=${PROJECT_NAME}:${GITHUB_SHA}
REMOTE_TAG?=302671405705.dkr.ecr.us-east-1.amazonaws.com/dev-cardeal-repo
CONTAINER_NAME=cardeal-test-api
IAM_USER=hermannproton
#############################################
# UTILS
check-env:
ifndef ENV
	$(error Please set ENV=[dev|prod])
endif 


#############################################
# AWS-VAULT
list-session:
	@aws-vault list

create-session:
	@aws-vault exec ${IAM_USER} --duration=12h

clear-session:
	@aws-vault clear ${IAM_USER}
#############################################
# AWS-DOCKER
docker-auth:
	aws ecr get-login-password  \
        --region ${REGION} | docker login \
        --username AWS \
        --password-stdin ${ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com
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
	@cd terraform/applications/${PROJECT_NAME} && \
		terraform workspace list

terraform-format: 
	@find . -type f -name "*.tf" -not -path '*/.terraform/*' -exec terraform fmt -write {} \;

terraform-validate:
	@find . -type f -name "*.tf" -not -path '*/.terraform/*' -exec terraform fmt {} \;

# terraform-init-ci:
# 	@cd terraform/applications/${PROJECT_NAME} && \
# 		terraform init \

terraform-validate-ci:
	@cd terraform/applications/${PROJECT_NAME} && \
	terraform init
	terraform workspace select ${ENV} && \
	terraform init  && \
	terraform validate && \
	find . -type f -name "*.tf" -not -path '*/.terraform/*' -exec terraform fmt -check {} \;

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
	
terraform-action:check-env
	@cd terraform/applications/${PROJECT_NAME} && \
		terraform ${TF_ACTION} -var="db_pass=postgres"

terraform-plan:check-env
	@cd terraform/applications/${PROJECT_NAME} && \
		terraform plan -var db_pass=${{secrets.DB_PASS }}

terraform-apply:check-env
	@cd terraform/applications/${PROJECT_NAME} && \
		terraform apply -var db_pass=${{secrets.DB_PASS }} -auto-approve

#############################################
## SSH
ssh:check-env
	@ssh -i ${KEY_PAIR} ${VM_HOST} -l ${USER}

#############################################
## DOCKER REMOTE
build:
		docker build -t ${LOCAL_TAG} .

build-test:
		docker build -t ${LOCAL_TAG} ./dockerfile-sample

push:
		docker tag ${LOCAL_TAG} ${REMOTE_TAG}:latest
		docker push ${REMOTE_TAG}

deploy:
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
						${REMOTE_TAG} \
	'

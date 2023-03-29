#############################################
# VARIABLES
PROJECT_NAME=api
ACCOUNT_ID=302671405705
TF_ACTION?=plan
REGION=us-east-1
USER=ec2-user
KEY_PAIR = ~/.ssh/aws_001
VM_HOST=ec2-54-227-127-141.compute-1.amazonaws.com
GITHUB_SHA?=latest
LOCAL_TAG=${PROJECT_NAME}:${GITHUB_SHA}
REMOTE_TAG?=302671405705.dkr.ecr.us-east-1.amazonaws.com/dev-backend-repo
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

######## LOCAL ########
tf-create-workspace:check-env
	@cd terraform/applications/bootstrap && \
		terraform workspace new ${ENV}

tf-check-workspace:
	@cd terraform/applications/bootstrap && \
		terraform workspace list

tf-switch-workspace:check-env
	@cd terraform/applications/bootstrap && \
		terraform workspace select ${ENV}

tf-format: 
	@find . -type f -name "*.tf" -not -path '*/.terraform/*' -exec terraform fmt -write {} \;

tf-validate:
	@find . -type f -name "*.tf" -not -path '*/.terraform/*' -exec terraform validate {} \;

tf-init:check-env
	@cd terraform/applications/bootstrap && \
		terraform workspace select ${ENV} && \
		terraform init \

tf-action:check-env
	@cd terraform/applications/bootstrap && \
	terraform workspace select ${ENV} && \
	terraform ${TF_ACTION} -var="db_pass=postgres"


######## CI/CD ########

terraform-init-ci:
	@cd terraform/applications/${PROJECT_NAME} && \
	terraform init \

terraform-validate-ci:check-env
	@cd terraform/applications/${PROJECT_NAME} && \
	terraform workspace select ${ENV} && \
	terraform init  && \
	terraform validate  \

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

push:
	 docker tag ${LOCAL_TAG} ${REMOTE_TAG}:latest
		docker push  ${REMOTE_TAG}



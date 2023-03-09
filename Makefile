### Variables
PROJECT_ID = devops-cardeal
### run docker locally
run:
	docker compose up -d
shutdown:
	docker compose down
rebuild:
	docker compose up -d --build 

### Terraform

create-tf-backen-bucket:
		gsutil mb -p ${PROJECT_ID} gs://${PROJECT_ID}-terraform
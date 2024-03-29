[{
	"name": "api",
	"image": "${app_image}",
	"essential": true,
	"memoryReservation": 512,
	"environment": [{
			"name": "DB_HOST",
			"value": "${db_host}"
		},
		{
			"name": "DB_NAME",
			"value": "${db_name}"
		},
		{
			"name": "DB_USER",
			"value": "${db_user}"
		},
		{
			"name": "DB_PASS",
			"value": "${db_pass}"
		},
		{
			"name": "S3_STORAGE_BUCKET_NAME",
			"value": "${s3_storage_bucket_name}"
		},
		{
			"name": "S3_STORAGE_BUCKET_REGION",
			"value": "${s3_storage_bucket_region}"
		}
	],
	"logConfiguration": {
		"logDriver": "awslogs",
		"options": {
			"awslogs-group": "${log_group_name}",
			"awslogs-region": "${log_group_region}",
			"awslogs-stream-prefix": "api"
		}
	},
	"portMappings": [{
		"containerPort": 8000,
		"hostPort": 8000
	}]
}]
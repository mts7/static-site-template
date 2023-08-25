#!/bin/bash

BUCKET="TODO:enter-bucket-name-here-backend-terraform-state"
AWS_REGION="us-east-1"
extra=""

if [[ "${AWS_REGION}" != "us-east-1" ]]; then
	extra="--region ${AWS_REGION} --create-bucket-configuration LocationConstraint=${AWS_REGION}"
fi

aws s3api create-bucket --bucket ${BUCKET} ${extra}

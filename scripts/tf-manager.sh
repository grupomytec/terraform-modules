#!/bin/ash

cd $TERRAFORM_DIR/templates/$STAGE-template/.iac

echo "* source .env files from \"$ENVIRONMENT\""
set -a 
source $ENV_DIR/*

terraform init -backend-config=$TF_S3_CREDENTIALS

if [ ! -z "$DESTROY" ]; then
   echo -e "* running terraform destroy on $PWD\n"
   terraform destroy -auto-approve
   exit 0
fi

echo -e "* running terraform validate on $PWD\n"

terraform validate

echo -e "* running terraform plan on $PWD\n"

terraform plan -out="tf_plan"

echo -e "* running terraform apply on $PWD\n"

terraform apply -input=false "tf_plan"
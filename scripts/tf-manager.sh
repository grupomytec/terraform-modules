#!/bin/ash

TF_PLAN_NAME="tf_plan"
ENV_FILE="$ENV_DIR/$STAGE.env"

cd $TF_CURRENT_ROOT

echo -e "* source .env files from \"$ENV_FILE\""

set -a 
while IFS= read -r line; do
  if [[ $line != \#* ]]; then  # Ignora linhas de comentários
    export "$line"
  fi
done < "$ENV_FILE"

echo -e "\n"

terraform init -backend-config=$BUCKET_CREDENTIALS

if [ ! -z "$DESTROY" ]; then
   echo -e "* running terraform destroy on $PWD\n"
   terraform destroy -auto-approve
   exit 0
fi

echo -e "* running terraform validate on $PWD\n"

terraform validate

echo -e "* running terraform plan on $PWD\n"

terraform plan -out=$TF_PLAN_NAME

echo -e "* running terraform apply on $PWD\n"

terraform apply -input=false $TF_PLAN_NAME
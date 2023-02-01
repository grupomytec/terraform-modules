#!/bin/ash
FULL_BUCKET_NAME="$APP_NAME\_$ENVIRONMENT"
TF_S3_STATE_DIR="terraform/$STAGE/terraform.tfstate"

cat <<EOF > $BUCKET_CREDENTIALS
bucket="$FULL_BUCKET_NAME"
key="$TF_S3_STATE_DIR"
region="$AWS_REGION"
EOF

aws s3 ls | grep -w "$FULL_BUCKET_NAME" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "bucket already exists ...\n"
    exit 0
fi

echo "* bucket wasn't created"

if [ -z "$FULL_BUCKET_NAME" ]; then
   echo "* bucket name's wasn't set"
   exit 1
fi

TF_LOCAL_S3_DIR="/tmp/tf"
TF_LOCAL_S3_FILE="$TF_LOCAL_S3_DIR/s3-create.tf"

echo "starting creation of s3 bucket $FULL_BUCKET_NAME ..."

mkdir -p "$TF_LOCAL_S3_DIR"

cat <<EOF > $TF_LOCAL_S3_FILE
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.74.3"
    }
  }
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "$FULL_BUCKET_NAME"
  acl    = "private"
}
EOF

cd $TF_LOCAL_S3_DIR

echo "* running terraform init on $PWD"

terraform init

echo "* running terraform plan on $PWD"

terraform plan

echo "* running terraform apply on $PWD"

terraform apply -auto-approve




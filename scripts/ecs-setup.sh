#!/bin/ash

BASEDIR=$(dirname $0)

TERRAFORM_DIR="/terraform"
BUCKET_CREATE="$BASEDIR/s3-manager.sh"

TF_S3_CREDENTIALS="$TERRAFORM_TMP_DIR/tf-s3.env"
TF_ENVS="$TERRAFORM_TMP_DIR/tf-envs.env"
TF_BUCKET_NAME="$APP_NAME-$ENVIRONMENT"

if [ $1 = "--stage" ] && [ ! -z $2 ]; then
   export STAGE=$2
fi

if [ -z "$STAGE" ]; then
   echo "* stage environment wasn't set"
   exit 1
fi

TERRAFORM_TMP_DIR="/tmp/$STAGE"

if [ $STAGE = "ecs-ec2-spotio" ]; then
   echo "* starting import ecs cluster to spot.io"
   cd "$TERRAFORM_DIR/ecs-ec2-spotio"
   ./spotio.py
   cd -
   exit 0
fi

if [ $STAGE = "ecs-ec2-cluster" ]; then
   USER_DATA="$TERRAFORM_TMP_DIR/user_data.sh"

   echo "* creating user_data.sh on $USER_DATA"

cat <<EOF > $USER_DATA
#!/bin/bash
echo ECS_CLUSTER=$APP_NAME >> /etc/ecs/ecs.config;echo ECS_BACKEND_HOST= >> /etc/ecs/ecs.config;
EOF
   export TF_VAR_USER_DATA=$( cat $USER_DATA | base64 -w 0 )
fi

TF_S3_STATE_DIR="terraform/$STAGE/terraform.tfstate"

mkdir -p $TERRAFORM_TMP_DIR

echo -e "starting ecs cluster creation step...\n"

if [ -z "$BUCKET_NAME" ] || [ -z $ENVIRONMENT ] || [ -z $APP_NAME ]; then
   echo "* bucket name's wasn't set"
   exit 1
else
   echo "* cluster name's setted to \"$APP_NAME\""
   export TF_VAR_CLUSTER_NAME=$APP_NAME
fi

if [ -z "$ENV_DIR" ]; then
   echo "* env dir wasn't set using default dir"
   ENV_DIR=$ENVIRONMENT
fi

# check if bucket exists if not creates it
ash $BUCKET_CREATE $TF_BUCKET_NAME $TF_S3_CREDENTIALS $TF_S3_STATE_DIR

cd $TERRAFORM_DIR/templates/$STAGE-template/.iac

echo "* source .env files"
set -a 
source $ENV_DIR/*

echo -e "* running terraform init on $PWD\n"

terraform init -backend-config=$TF_S3_CREDENTIALS

if [ ! -z $DESTROY ] || [ $1 = "--destroy" ] || [ $3 = "--destroy" ]; then
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


# .env .secret 
#for i in `cat ./$branchdir/*.secrets`; do
#   if [[ $i != \#* ]]; then
#   echo $i | awk -F= '{print "{"; print "\t\"name\" = " "\""$1"\"""," ; print "\t\"valueFrom\" = " "\""$2"\"" ; print "}," }' >> $GITHUB_ENV
#   fi
#done
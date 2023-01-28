#!/bin/ash

BASEDIR=$(dirname $0)

if [ "$1" = "--stage" ] && [ ! -z "$2" ]; then
   export STAGE=$2
fi

if [ "$3" = "--destroy" ]; then
   export DESTROY=true
fi

export TERRAFORM_DIR="/opt/terraform"
export SCRIPTS_DIR="$TERRAFORM_DIR/scripts"
export TERRAFORM_TMP_DIR="/tmp/$STAGE"
export TF_S3_CREDENTIALS="$TERRAFORM_TMP_DIR/tf-s3.env"
export USER_DATA="$TERRAFORM_TMP_DIR/user_data.sh"

BUCKET_CREATE="$BASEDIR/s3-manager.sh"
TF_ENVS="$TERRAFORM_TMP_DIR/tf-envs.env"

# create a temp dir to store files
mkdir -p $TERRAFORM_TMP_DIR

if [ -z $ENVIRONMENT ] || [ -z $APP_NAME ] || [ -z $CLUSTER_NAME ]; then
   echo "* bucket or cluster name's wasn't set"
   exit 1
else
   echo "* cluster name's sat to \"$CLUSTER_NAME\""
   export TF_VAR_CLUSTER_NAME=$CLUSTER_NAME
   export TF_VAR_APP_NAME=$APP_NAME
fi

if [ -z "$ENV_DIR" ]; then
   echo "* env dir wasn't set using default dir"
   ENV_DIR=$ENVIRONMENT
fi

if [ -z "$STAGE" ]; then
   echo "* stage environment wasn't set"
   exit 1
fi

case $STAGE in
"ecs-ec2-spotio") ash $SCRIPTS_DIR/ecs-spotio.sh && exit 0 ;;

"ecs-ec2-cluster") ash $SCRIPTS_DIR/ecs-cluster.sh && export TF_VAR_USER_DATA=$( cat $USER_DATA | base64 -w 0 ) ;;

"ecs-ec2-service") ash $SCRIPTS_DIR/ecs-service.sh ;;

"ecs-ec2-alb") ash $SCRIPTS_DIR/ecs-alb.sh ;;
*) 
   echo "the stage \"$STAGE\" doesn't exists ..." && exit 1 ;;
esac

echo -e "starting terraform modules step...\n"

ash $SCRIPTS_DIR/s3-manager.sh

echo -e "* running terraform init on $PWD\n"

ash $SCRIPTS_DIR/tf-manager.sh
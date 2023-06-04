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
export BUCKET_CREDENTIALS="$TERRAFORM_TMP_DIR/tf-s3.env"
export USER_DATA="$TERRAFORM_TMP_DIR/user_data.sh"
#export TF_CURRENT_ROOT="$TERRAFORM_DIR/templates/$STAGE-template/.iac"
export TF_CURRENT_ROOT="$TERRAFORM_DIR/templates/$STAGE-template"
export APP_ENVS="$TERRAFORM_TMP_DIR"

export ALB_TG_ARN_FILE="$TERRAFORM_DIR/$STAGE/alb_target_group_arn.txt"
export ALB_LST_ARN_FILE="$TERRAFORM_DIR/$STAGE/alb_listner_arn.txt"

export TF_VAR_AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
export TF_VAR_AWS_REGION="$AWS_REGION"

BUCKET_CREATE="$BASEDIR/s3-manager.sh"
TF_ENVS="$TERRAFORM_TMP_DIR/tf-envs.env"

# create a temp dir to store files
mkdir -p $TERRAFORM_TMP_DIR

if [ -z $ENVIRONMENT ] || [ -z $APP_NAME ] || [ -z $CLUSTER_NAME ]; then
   echo "* bucket or cluster's name wasn't set"
   exit 1
else
   echo "* cluster's name sat to \"$CLUSTER_NAME\""
   export TF_VAR_CLUSTER_NAME=$CLUSTER_NAME
   export TF_VAR_APP_NAME=$APP_NAME
fi

if [ -z "$STAGE" ]; then
   echo "* stage environment wasn't set"
   exit 1
fi

if [ -z "$ENV_DIR" ]; then
   echo "* env dir wasn't set using default dir"
   export ENV_DIR="$TF_CURRENT_ROOT/$ENVIRONMENT"
fi

export APP_ENV_FILE="$ENV_DIR/app.json"
export APP_ENV_SECRETS_FILE="$ENV_DIR/app-secrets.json"

PARSED_NAME=$(echo "$APP_NAME" | sed -E 's/(\W|_)/-/g')
LOAD_BALANCER_NAME="$PARSED_NAME-aws-alb"

# if [ -z "$LOAD_BALANCER_NAME" ]; then
#    echo "* using load balancer arn from \"$ENV_DIR\""
#    export TF_VAR_LOAD_BALANCER_ARN=$$LOAD_BALANCER_ARN
#    LOAD_BALANCER_NAME="$(echo "$LOAD_BALANCER_ARN" | cut -d '/' -f 3)"
# fi

LOAD_BALANCER_ARN=$(aws elbv2 describe-load-balancers --region $AWS_REGION --output text --query "LoadBalancers[?LoadBalancerName=='$LOAD_BALANCER_NAME'].LoadBalancerArn")

if [ ! "$LOAD_BALANCER_ARN" = "" ]; then
   echo -e "* exporting load balancer target group arn from aws cli\n"
   export TF_VAR_LOAD_BALANCER_TARGET_GROUP="$(aws elbv2 describe-target-groups --region $AWS_REGION --output text --load-balancer-arn $LOAD_BALANCER_ARN --query "TargetGroups[0].TargetGroupArn")"

   echo -e "* exporting load balancer listner arn from aws cli\n"
   export TF_VAR_LOAD_BALANCER_LISTNER="$(aws elbv2 describe-listeners --region $AWS_REGION --output text --load-balancer-arn $LOAD_BALANCER_ARN --query "Listeners[0].ListenerArn")"
fi

if [ -f "$ALB_TG_ARN_FILE" ] && [ -f "$ALB_LST_ARN_FILE" ]; then
   echo "* using load balancer target group arn from \"$ARN_FILE\""
   export TF_VAR_LOAD_BALANCER_TARGET_GROUP="$(cat $ALB_TG_ARN_FILE)"

   echo "* using load balancer listner arn from \"$ARN_FILE\""
   export TF_VAR_LOAD_BALANCER_LISTNER="$(cat $ALB_LST_ARN_FILE)"
fi

case $STAGE in
"ecs-ec2-spotio") ash $SCRIPTS_DIR/ecs-spotio.sh && exit 0 ;;

"ecs-ec2-cluster") ash $SCRIPTS_DIR/ecs-cluster.sh && \
                  export TF_VAR_USER_DATA=$( cat $USER_DATA | base64 -w 0 ) ;;

"ecs-ec2-service") ash $SCRIPTS_DIR/ecs-service.sh && \
                  export TF_VAR_TASK_ENVIRONMENT=$( cat "$APP_ENV_FILE" )  && \
                  export TF_VAR_TASK_SECRETS=$( cat "$APP_ENV_SECRETS_FILE" )  ;;

"ecs-fargate-service") ash $SCRIPTS_DIR/ecs-service.sh && \
                  export TF_VAR_TASK_ENVIRONMENT=$( cat "$APP_ENV_FILE" )  && \
                  export TF_VAR_TASK_SECRETS=$( cat "$APP_ENV_SECRETS_FILE" )  ;;

"ecs-fargate-cluster") ;;  #;;

"ecs-ec2-alb") ;;  #ash $SCRIPTS_DIR/ecs-lb.sh ;;

*) echo "the stage \"$STAGE\" doesn't exists ..." && exit 1 ;;
esac

echo -e "starting terraform modules step...\n"

ash $SCRIPTS_DIR/s3-manager.sh

echo -e "* running terraform init on $PWD\n"

ash $SCRIPTS_DIR/tf-manager.sh
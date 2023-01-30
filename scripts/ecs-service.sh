#.env .secret 
export APP_ENVS="$TERRAFORM_TMP_DIR"
export APP_ENV_FILE="$ENV_DIR/app.json"
export APP_ENV_SECRETS_FILE="$ENV_DIR/app-secrets.json"

if test -f "$LB_ARN_FILE"; then
   echo "* Using load balancer from \"$ARN_FILE\""
   export TF_VAR_LOAD_BALANCER="$(cat $ARN_FILE)"
fi

if [ ! -f "$APP_ENV_FILE" ]; then
   echo "* setting up empty app env configuration files"
   echo "{}" > $APP_ENV_FILE
fi

if [ ! -f "$APP_ENV_SECRETS_FILE"]; then
   echo "* setting up empty app env secrets configuration files"
   echo "{}" > $APP_ENV_SECRETS_FILE
fi

export TF_VAR_TASK_ENVIRONMENT=$APP_ENV_FILE
export TF_VAR_TASK_SECRETS=$APP_ENV_SECRETS_FILE

#for i in `cat ./$branchdir/*.secrets`; do
#   if [[ $i != \#* ]]; then
#   echo $i | awk -F= '{print "{"; print "\t\"name\" = " "\""$1"\"""," ; print "\t\"valueFrom\" = " "\""$2"\"" ; print "}," }' >> $GITHUB_ENV
#   fi
#done
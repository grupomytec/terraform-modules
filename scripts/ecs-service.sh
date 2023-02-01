#.env .secret 

if [ ! -f "$APP_ENV_FILE" ]; then
   echo "* setting up empty app env configuration files"
   echo "{}" > $APP_ENV_FILE
fi

if [ ! -f "$APP_ENV_SECRETS_FILE" ]; then
   echo "* setting up empty app env secrets configuration files"
   echo "{}" > $APP_ENV_SECRETS_FILE
fi

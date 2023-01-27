echo "* creating user_data.sh on $USER_DATA"

# if this part was changed problems with autoscaling group maybe occur!
cat <<EOF > $USER_DATA
#!/bin/bash
echo ECS_CLUSTER=$CLUSTER_NAME >> /etc/ecs/ecs.config;echo ECS_BACKEND_HOST= >> /etc/ecs/ecs.config;
EOF

echo "* loading user_data.sh as base64 to env"
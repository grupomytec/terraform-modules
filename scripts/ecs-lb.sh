if test -f "$LB_ARN_FILE"; then
    echo "* Using load balancer from \"$ARN_FILE\""
    exit 0
fi

echo "* load balancer wasn't declared"

exit 1
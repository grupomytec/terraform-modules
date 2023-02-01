#!/bin/ash


cd "$TERRAFORM_DIR/ecs-ec2-spotio"

if [ ! -z "$DESTROY" ]; then
   echo -e "* removing cluster from spotio\n"
   ./spotio.py --remove
   exit 0
fi

echo "* starting import ecs cluster to spot.io"

./spotio.py --import

cd -

exit 0
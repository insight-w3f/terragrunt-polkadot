set -e

# latest commit
LATEST_COMMIT=$(git rev-parse HEAD)
AWS_COMMIT=$(git log -1 --format=format:%H --full-diff polkadot/aws)
PACKET_COMMIT=$(git log -1 --format=format:%H --full-diff polkadot/packet)

if [ $AWS_COMMIT = $LATEST_COMMIT ];
    then
        make test-aws
elif [ $PACKET_COMMIT = $LATEST_COMMIT ];
    then
        make test-packet
else
     echo "No target folders have changed"
     exit 0;
fi

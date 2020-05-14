set -e

LATEST_COMMIT=$(git rev-parse HEAD)
STACKS=$(find ./icon -maxdepth 1 -type d -printf '%P\n')

for s in $STACKS ; do
  PROVIDERS=$(find ./icon/"$s" -maxdepth 1 -type d -printf '%P\n')
  for p in $PROVIDERS ; do
    PROVIDER_COMMIT=$(git log -1 --format=format:%H --full-diff icon/"$s"/"$p")
    if [ "$PROVIDER_COMMIT" = "$LATEST_COMMIT" ]; then
      (cd icon/"$s"/"$p" && make test)
    fi
  done
done

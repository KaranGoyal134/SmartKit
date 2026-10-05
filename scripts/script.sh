#!/bin/bash

set -e

SERVICE="$1"
TAG="$2"

if [ -z "$SERVICE" ] || [ -z "$TAG" ]; then
    echo "Usage: ./scripts/script.sh <frontend|backend> <tag>"
    exit 1
fi

case "$SERVICE" in

    frontend)
        MANIFEST="k8s-manifests/frontend-deployment.yaml"
        IMAGE="$DOCKER_USERNAME/smartkit-frontend"
        ;;

    backend)
        MANIFEST="k8s-manifests/backend-deployment.yaml"
        IMAGE="$DOCKER_USERNAME/smartkit-backend"
        ;;

    *)
        echo "Invalid service: $SERVICE"
        echo "Use frontend or backend"
        exit 1
        ;;
esac

echo "Updating $SERVICE image..."
echo "Image: $IMAGE"
echo "Tag: $TAG"

sed -i -E \
    "s|image: ${IMAGE}:.*|image: ${IMAGE}:${TAG}|" \
    "$MANIFEST"

echo "Updated image:"
grep "image:" "$MANIFEST"

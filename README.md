## kubectl docker image


### Build

1. within kubernetes v1.25
```bash
tag=v1.25 && \
# tag="$tag-$(date +%Y%m%d%H%M%S)" && \
docker buildx build \
--platform linux/amd64,linux/arm64 \
--build-arg KUBECTL_VERSION=v1.25.12 \
--build-arg HELM_VERSION=v3.12.2 \
# --push \
# --load \
-t kit101z/kubectl:$tag .
```

2. within kubernetes v1.23
```bash
tag=v1.23 && \
# tag="$tag-$(date +%Y%m%d%H%M%S)" && \
docker buildx build \
--platform linux/amd64,linux/arm64 \
--build-arg KUBECTL_VERSION=v1.23.8 \
--build-arg HELM_VERSION=v3.11.3 \
# --push \
# --load \
-t kit101z/kubectl:$tag .
```

## kubectl docker image


本地构建发布(mac环境)

```bash
# 新增构建环境
docker buildx create --use --name=mybuilder-cn --driver docker-container --driver-opt image=dockerpracticesig/buildkit:master

# 执行构建
# 不加--push，讲提示 WARNING: No output specified with docker-container driver. Build result will only remain in the build cache. To push result image into registry use --push or to load image into docker use --load
docker buildx build --platform linux/amd64,linux/arm64 --push --file ./Dockerfile -t kit101z/kubectl:v1.23.8 .
```
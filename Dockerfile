FROM alpine:3.18.2

ARG KUBECTL_VERSION=v1.27.4
ARG HELM_VERSION=v3.12.2
ARG TARGETOS
ARG TARGETARCH
ARG FILEBROWSER_VERSION=v2.42.5

RUN apk update && apk add \
   bash \
   bash-completion \
   busybox-extras \
   net-tools \
   vim \
   curl \
   wget \
   tcpdump \
   ca-certificates && \
   update-ca-certificates && \
   rm -rf /var/cache/apk/* && \
   curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/${TARGETOS}/${TARGETARCH}/kubectl && \
   chmod +x ./kubectl && \
   mv ./kubectl /usr/local/bin/kubectl && \
   echo -e 'source /usr/share/bash-completion/bash_completion\nsource <(kubectl completion bash)' >>~/.bashrc && \
   curl -SsLO https://get.helm.sh/helm-${HELM_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz && \
   tar xf helm-${HELM_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz -C /usr/local/bin && \ 
   mv /usr/local/bin/${TARGETOS}-${TARGETARCH}/helm /usr/local/bin && \
   rm helm-${HELM_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz && \
   rm -rf /usr/local/bin/${TARGETOS}-${TARGETARCH}

RUN filebrowser_download_url=https://github.com/filebrowser/filebrowser/releases/download/${FILEBROWSER_VERSION}/${TARGETOS}-${TARGETARCH}-filebrowser.tar.gz && \
    mkdir -p /tmp/filebrowser/ && cd /tmp/filebrowser && \
    wget -O filebrowser.tar.gz ${filebrowser_download_url} && \
    tar xf filebrowser.tar.gz && \
    mv filebrowser /usr/local/bin && \
    rm -rf /tmp/filebrowser && \
    mkdir /etc/filebrowser/

COPY filebrowser/.filebrowser.json /etc/filebrowser/.filebrowser.json

ENV FB_DISABLE_EXEC=true

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
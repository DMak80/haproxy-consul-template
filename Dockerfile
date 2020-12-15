FROM project42/s6-alpine:latest

MAINTAINER cavemandaveman <cavemandaveman@protonmail.com>

ENV CONSUL_TEMPLATE_VERSION="0.25.1" \
    CONSUL_TEMPLATE_SHA256="58356ec125c85b9705dc7734ed4be8491bb4152d8a816fd0807aed5fbb128a7b"

RUN set -x \
    && apk --no-cache add haproxy \
    && apk --no-cache add --virtual .install-deps \
    && export WGETHOME="$(mktemp -d)" \
    && wget -q "https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip" -P "${WGETHOME}" \
    && echo "${CONSUL_TEMPLATE_SHA256}  ${WGETHOME}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip" | sha256sum -c \
    && unzip -qd "/bin/" "${WGETHOME}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip" \
    && apk del .install-deps

COPY etc/ /etc/
COPY bin/ /bin/

ENTRYPOINT ["/init"]

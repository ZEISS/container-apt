FROM python:3-alpine

COPY install_hashicorp.sh /usr/local/share/hashicorp/install.sh

RUN set -eux; \
    apk --update add --no-cache \
        coreutils \
        curl \
        wget \
        bash \
        git \
        openssh \
        sshpass \
        openssl \
        krb5 \
        krb5-dev \
    ; \
    apk add --no-cache --virtual .build-deps \
        gcc \
        make \
        musl-dev \
        libffi-dev \
        libxml2-dev \
        libxslt-dev \
        openssl-dev \
        gnupg \
    ; \
    \
    pip install --no-cache-dir \
        ansible \
        pywinrm[kerberos,credssp] \
        docker \
        tox \
        molecule \
        git+https://github.com/boto/botocore.git@v2 \
        git+https://github.com/aws/aws-cli.git@v2 \
        ansible[azure] \
        azure-cli \
        requests[security] \
        dns-lexicon[full] \
    ; \
    \
    chmod +x /usr/local/share/hashicorp/install.sh; \
    /usr/local/share/hashicorp/install.sh; \
    \
    apk del .build-deps

RUN set -eux; \
    git clone --depth 1 https://github.com/dehydrated-io/dehydrated.git /usr/local/etc/dehydrated; \
    ln -s /usr/local/etc/dehydrated/dehydrated /usr/local/bin/dehydrated; \
    mkdir -p /usr/local/etc/dehydrated/hooks; \
    wget -O /usr/local/etc/dehydrated/hooks/lexicon.sh https://raw.githubusercontent.com/AnalogJ/lexicon/master/examples/dehydrated.default.sh

WORKDIR /srv

CMD [ "sh","-c","while true ; do sleep 1 ; done" ]
FROM python:3-alpine

RUN set -eux; \
    apk --update add --no-cache \
        coreutils \
        curl \
        wget \
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
    ; \
    \
    pip install --no-cache-dir \
        ansible \
        pywinrm[kerberos,credssp] \
        docker \
        boto3 \
        ansible[azure] \
        tox \
        molecule \
        awscli \
        azure-cli \
        requests[security] \
        dns-lexicon[full] \
    ; \
    apk del .build-deps

RUN set -eux; \
    git clone --depth 1 https://github.com/dehydrated-io/dehydrated.git /usr/local/etc/dehydrated; \
    ln -s /usr/local/etc/dehydrated/dehydrated /usr/local/bin/dehydrated; \
    mkdir -p /usr/local/etc/dehydrated/hooks; \
    wget -O /usr/local/etc/dehydrated/hooks/lexicon.sh https://raw.githubusercontent.com/AnalogJ/lexicon/master/examples/dehydrated.default.sh

WORKDIR /srv

CMD [ "sh","-c","while true ; do sleep 1 ; done" ]

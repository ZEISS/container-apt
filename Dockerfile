FROM python:3.8-alpine

ENV DEFAULT_TZ=Europe/Berlin \
    LANG=de_DE.UTF-8 \
    LANGUAGE=de_DE.UTF-8 \
    LC_ALL=de_DE.UTF-8

COPY requirements.pip /usr/local/share/ansible/requirements.compile
COPY install-hashicorp-cli.sh /usr/local/share/hashicorp/install-cli.sh
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
        openjdk8-jre-lib \
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
        tzdata \
    ; \
    \
    cp /usr/share/zoneinfo/${DEFAULT_TZ} /etc/localtime; \
    echo "${DEFAULT_TZ}" >/etc/timezone; \
    \
    pip install --no-cache-dir pip-tools;\
    pip-compile /usr/local/share/ansible/requirements.compile; \
    pip install --no-cache-dir -r /usr/local/share/ansible/requirements.txt; \
    \
    chmod +x /usr/local/share/hashicorp/install-cli.sh; \
    /usr/local/share/hashicorp/install-cli.sh packer terraform; \
    \
    git clone --depth 1 https://github.com/dehydrated-io/dehydrated.git /usr/local/etc/dehydrated; \
    ln -s /usr/local/etc/dehydrated/dehydrated /usr/local/bin/dehydrated; \
    mkdir -p /usr/local/etc/dehydrated/hooks; \
    wget -qO /usr/local/etc/dehydrated/hooks/lexicon.sh https://raw.githubusercontent.com/AnalogJ/lexicon/master/examples/dehydrated.default.sh; \
    \
    apk del .build-deps

COPY config /tmp/config
RUN set -eux; \
    if [ "$(uname -m)" = "x86_64" -a "$(getconf LONG_BIT)" = "64" ]; then \
        curl -Os https://starship.rs/install.sh; \
        chmod +x ./install.sh; \
        ./install.sh -f; \
        rm install.sh; \
        mkdir -p ~/.config; \
        mv /tmp/config/starship.toml ~/.config/starship.toml; \
    fi; \
    mv /tmp/config/.bashrc ~/.bashrc; \
    \
    apk --update add --no-cache fontconfig vim; \
    apk --update add --no-cache font-noto-emoji --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community; \
    wget -q https://github.com/ryanoasis/nerd-fonts/releases/latest/download/SourceCodePro.zip; \
    mkdir -p /usr/share/fonts/nerd; \
    unzip -d /usr/share/fonts/nerd SourceCodePro.zip; \
    rm SourceCodePro.zip; \
    find /usr/share/fonts/nerd/ -type f -name "*Windows Compatible.ttf" -exec rm -f {} \;; \
    mv /tmp/config/nerd-emoji-font.conf /usr/share/fontconfig/conf.avail/05-nerd-emoji.conf; \
    ln -s /usr/share/fontconfig/conf.avail/05-nerd-emoji.conf /etc/fonts/conf.d/05-nerd-emoji.conf; \
    fc-cache -vf; \
    mv /tmp/config/.vimrc ~/.vimrc; \
    # vim -c 'PlugInstall' -c 'qa!'; \
    rm -rf /tmp/config

WORKDIR /srv

CMD [ "sh","-c","while true ; do sleep 1 ; done" ]

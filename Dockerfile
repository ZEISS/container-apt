FROM python:3.9-alpine

ENV TIMEZONE=${TIMEZONE:-Europe/Berlin} \
    LANG=${LANGUAGE:-de_DE}.${ENCODING:-UTF-8} \
    LANGUAGE=${LANGUAGE:-de_DE}.${ENCODING:-UTF-8} \
    LC_ALL=${LANGUAGE:-de_DE}.${ENCODING:-UTF-8}

COPY python.pkgs /usr/local/share/pip/compile.pkgs
RUN set -eux; \
    # Install permanent system packages
    apk --update add --no-cache \
        coreutils \
        curl \
        wget \
        bash \
        zip \
        git \
        jq \
        openssl \
        openssh \
        sshpass \
        krb5 \
        krb5-dev \
        #openjdk11-jre-headless \
    ; \
    # Install build-dependent system packages
    apk add --no-cache --virtual .build-deps \
        gcc \
        make \
        musl-dev \
        libffi-dev \
        libxml2-dev \
        libxslt-dev \
        openssl-dev \
        cargo \
        rust \
        gnupg \
        tzdata \
    ; \
    \
    # Set timezone
    cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime; \
    echo "${TIMEZONE}" >/etc/timezone; \
    \
    # Install Ansible, Azure, AWS and DNS python packages
    python -m pip install --upgrade pip; \
    pip install --no-cache-dir pip-tools; \
    pip-compile -qo /usr/local/share/pip/install.pkgs /usr/local/share/pip/compile.pkgs; \
    pip install --no-cache-dir -r /usr/local/share/pip/install.pkgs; \
    pip cache purge; \
    \
    # Install HashiCorp binaries
    mkdir -p /usr/local/share/hashicorp; \
    wget -qO /usr/local/share/hashicorp/install.sh https://raw.github.com/zeiss/install-hashicorp-binaries/master/install-hashicorp.sh; \
    chmod +x /usr/local/share/hashicorp/install.sh; \
    /usr/local/share/hashicorp/install.sh packer terraform; \
    \
    # Install ACME client
    git clone --depth 1 https://github.com/dehydrated-io/dehydrated.git /usr/local/etc/dehydrated; \
    ln -s /usr/local/etc/dehydrated/dehydrated /usr/local/bin/dehydrated; \
    mkdir -p /usr/local/etc/dehydrated/hooks; \
    wget -qO /usr/local/etc/dehydrated/hooks/lexicon.sh https://raw.githubusercontent.com/AnalogJ/lexicon/master/examples/dehydrated.default.sh; \
    \
    apk del .build-deps

COPY config /tmp/config
RUN set -eux; \
    # Configure shell env
    mv /tmp/config/.bashrc ~/.bashrc; \
    # Install shell prompt
    curl -Os https://starship.rs/install.sh; \
    chmod +x ./install.sh; \
    ./install.sh -V -f; \
    rm install.sh; \
    mkdir -p ~/.config; \
    mv /tmp/config/starship.toml ~/.config/starship.toml; \
    # Install fonts
    apk --update add --no-cache \
        fontconfig \
        font-noto-emoji \
    ; \
    wget -q https://github.com/ryanoasis/nerd-fonts/releases/latest/download/SourceCodePro.zip; \
    mkdir -p /usr/share/fonts/nerd; \
    unzip -d /usr/share/fonts/nerd SourceCodePro.zip; \
    rm SourceCodePro.zip; \
    find /usr/share/fonts/nerd/ -type f -name "*Windows Compatible.ttf" -exec rm -f {} \;; \
    mv /tmp/config/nerd-emoji-font.conf /usr/share/fontconfig/conf.avail/05-nerd-emoji.conf; \
    ln -s /usr/share/fontconfig/conf.avail/05-nerd-emoji.conf /etc/fonts/conf.d/05-nerd-emoji.conf; \
    fc-cache -vf; \
    # Install build-dependent system packages
    apk add --no-cache --virtual .build-deps \
        gcc \
        make \
        musl-dev \
        ncurses-dev \
    ; \
    # Install editor
    git clone https://github.com/vim/vim.git /tmp/vim; \
    cd /tmp/vim; \
    ./configure \
        --with-features=huge \
        --enable-multibyte \
        --enable-python3interp=yes \
        --with-python3-config-dir=$(python3-config --configdir) \
        --enable-cscope \
        --prefix=/usr/local \
    ; \
    vim_version="$(git describe --tags $(git rev-list --tags --max-count=1) | sed -E 's/^v?([0-9]+)\.([0-9]+).*$/\1\2/')"; \
    make VIMRUNTIMEDIR=/usr/local/share/vim/vim${vim_version}; \
    make install; \
    rm -rf /tmp/vim; \
    mv /tmp/config/.vimrc ~/.vimrc; \
    # vim -c 'PlugInstall' -c 'qa!'; \
    \
    apk del .build-deps; \
    rm -rf /tmp/config

WORKDIR /srv

CMD [ "/bin/sh","-c","sleep infinity & wait" ]

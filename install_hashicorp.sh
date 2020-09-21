#!/usr/bin/env bash
set -Eeo pipefail
# TODO add "-u"

install_tool(){
    local name="$1" version="${2:-latest}" arch
    local check_url="https://checkpoint-api.hashicorp.com/v1/check" download_url="https://releases.hashicorp.com"

    # Check out the latest version
    if [ "${version}" == "latest" ]; then
        version="$(curl -s ${check_url}/${name} | sed -En 's/.*"current_version":"?([^,"]*)"?.*/\1/p')"
    fi
    # Check out the linux kernel architecture
    if [ "$(uname -m)" == "x86_64" ] && [ "$(getconf LONG_BIT)" == "64" ]; then
        arch="amd64"
    elif [ "$(uname -m)" == "x86_64" ] && [ "$(getconf LONG_BIT)" == "32" ]; then
        arch="386"
    elif [ "$(uname -m)" == "aarch64" ]; then
        arch="arm64"
    else
        exit 1
    fi
    # Download the archive and signature files
    curl -Os ${download_url}/${name}/${version}/${name}_${version}_linux_${arch}.zip
    curl -Os ${download_url}/${name}/${version}/${name}_${version}_SHA256SUMS
    curl -Os ${download_url}/${name}/${version}/${name}_${version}_SHA256SUMS.sig
    # Verify the signature file is untampered
    gpg --verify ${name}_${version}_SHA256SUMS.sig ${name}_${version}_SHA256SUMS
    # Verify the SHASUM matches the archive
    grep ${name}_${version}_linux_${arch}.zip ${name}_${version}_SHA256SUMS | sha256sum -c
    # Extract archive
    unzip ${name}_${version}_linux_${arch}.zip >/dev/null
    chmod +x ${name}
    mv ${name} /usr/local/bin/${name}
    # Verify the tool installation
    ${name}
    # Clean up the archive and signature files
    rm ${name}_${version}_linux_${arch}.zip
    rm ${name}_${version}_SHA256SUMS
    rm ${name}_${version}_SHA256SUMS.sig
}

# Import Hashicorp public key
# https://www.hashicorp.com/security
curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --import -
# Install Hashicorp tools
install_tool packer
install_tool terraform
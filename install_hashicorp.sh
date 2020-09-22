#!/usr/bin/env bash
set -Eeo pipefail
# TODO add "-u"

install_hashicorp(){
    local name="$1" version="${2:-latest}" osarch
    local check_url="https://checkpoint-api.hashicorp.com/v1/check" download_url="https://releases.hashicorp.com"

    # Check out the latest version
    if [ "${version}" == "latest" ]; then
        version="$(curl -s ${check_url}/${name} | sed -En 's/.*"current_version":"?([^,"]*)"?.*/\1/p')"
    fi
    # Check out the linux kernel architecture
    if [ "$(uname -m)" == "x86_64" ] && [ "$(getconf LONG_BIT)" == "64" ]; then
        osarch="amd64"
    elif [ "$(uname -m)" == "x86_64" ] && [ "$(getconf LONG_BIT)" == "32" ]; then
        ossarch="386"
    elif [ "$(uname -m)" == "aarch64" ]; then
        osarch="arm64"
    else
        exit 1
    fi
    # Download the archive and signature files
    curl -Os ${download_url}/${name}/${version}/${name}_${version}_linux_${osarch}.zip
    curl -Os ${download_url}/${name}/${version}/${name}_${version}_SHA256SUMS
    curl -Os ${download_url}/${name}/${version}/${name}_${version}_SHA256SUMS.sig
    # Verify the signature file is untampered
    gpg --verify ${name}_${version}_SHA256SUMS.sig ${name}_${version}_SHA256SUMS
    # Verify the SHASUM matches the archive
    sed -i "/linux_${osarch}\.zip/!d" ${name}_${version}_SHA256SUMS
    sha256sum -c ${name}_${version}_SHA256SUMS
    # Extract archive
    unzip ${name}_${version}_linux_${osarch}.zip >/dev/null
    chmod +x ${name}
    mv -f ${name} /usr/local/bin/${name}
    # Clean up the archive and signature files
    rm ${name}_${version}_linux_${osarch}.zip
    rm ${name}_${version}_SHA256SUMS
    rm ${name}_${version}_SHA256SUMS.sig
    # Verify the installation
    if [ "$(${name} --version | sed -En 's/^.*?([0-9]+\.[0-9]+\.[0-9]+).*$/\1/p')" == "${version}" ]; then
        echo >&2 "Installing ${name} (${version}): OK"
    fi
}

# Import Hashicorp PGP key
# https://www.hashicorp.com/security
cat >hashicorp.asc <<EOF
-----BEGIN PGP PUBLIC KEY BLOCK-----
                 
mQENBFMORM0BCADBRyKO1MhCirazOSVwcfTr1xUxjPvfxD3hjUwHtjsOy/bT6p9f
W2mRPfwnq2JB5As+paL3UGDsSRDnK9KAxQb0NNF4+eVhr/EJ18s3wwXXDMjpIifq
fIm2WyH3G+aRLTLPIpscUNKDyxFOUbsmgXAmJ46Re1fn8uKxKRHbfa39aeuEYWFA
3drdL1WoUngvED7f+RnKBK2G6ZEpO+LDovQk19xGjiMTtPJrjMjZJ3QXqPvx5wca
KSZLr4lMTuoTI/ZXyZy5bD4tShiZz6KcyX27cD70q2iRcEZ0poLKHyEIDAi3TM5k
SwbbWBFd5RNPOR0qzrb/0p9ksKK48IIfH2FvABEBAAG0K0hhc2hpQ29ycCBTZWN1
cml0eSA8c2VjdXJpdHlAaGFzaGljb3JwLmNvbT6JAU4EEwEKADgWIQSRpuf4XQXG
VjC+8YlRhS2HNI/8TAUCXn0BIQIbAwULCQgHAgYVCgkICwIEFgIDAQIeAQIXgAAK
CRBRhS2HNI/8TJITCACT2Zu2l8Jo/YLQMs+iYsC3gn5qJE/qf60VWpOnP0LG24rj
k3j4ET5P2ow/o9lQNCM/fJrEB2CwhnlvbrLbNBbt2e35QVWvvxwFZwVcoBQXTXdT
+G2cKS2Snc0bhNF7jcPX1zau8gxLurxQBaRdoL38XQ41aKfdOjEico4ZxQYSrOoC
RbF6FODXj+ZL8CzJFa2Sd0rHAROHoF7WhKOvTrg1u8JvHrSgvLYGBHQZUV23cmXH
yvzITl5jFzORf9TUdSv8tnuAnNsOV4vOA6lj61Z3/0Vgor+ZByfiznonPHQtKYtY
kac1M/Dq2xZYiSf0tDFywgUDIF/IyS348wKmnDGjuQENBFMORM0BCADWj1GNOP4O
wJmJDjI2gmeok6fYQeUbI/+Hnv5Z/cAK80Tvft3noy1oedxaDdazvrLu7YlyQOWA
M1curbqJa6ozPAwc7T8XSwWxIuFfo9rStHQE3QUARxIdziQKTtlAbXI2mQU99c6x
vSueQ/gq3ICFRBwCmPAm+JCwZG+cDLJJ/g6wEilNATSFdakbMX4lHUB2X0qradNO
J66pdZWxTCxRLomPBWa5JEPanbosaJk0+n9+P6ImPiWpt8wiu0Qzfzo7loXiDxo/
0G8fSbjYsIF+skY+zhNbY1MenfIPctB9X5iyW291mWW7rhhZyuqqxN2xnmPPgFmi
QGd+8KVodadHABEBAAGJATwEGAECACYCGwwWIQSRpuf4XQXGVjC+8YlRhS2HNI/8
TAUCXn0BRAUJEvOKdwAKCRBRhS2HNI/8TEzUB/9pEHVwtTxL8+VRq559Q0tPOIOb
h3b+GroZRQGq/tcQDVbYOO6cyRMR9IohVJk0b9wnnUHoZpoA4H79UUfIB4sZngma
enL/9magP1uAHxPxEa5i/yYqR0MYfz4+PGdvqyj91NrkZm3WIpwzqW/KZp8YnD77
VzGVodT8xqAoHW+bHiza9Jmm9Rkf5/0i0JY7GXoJgk4QBG/Fcp0OR5NUWxN3PEM0
dpeiU4GI5wOz5RAIOvSv7u1h0ZxMnJG4B4MKniIAr4yD7WYYZh/VxEPeiS/E1CVx
qHV5VVCoEIoYVHIuFIyFu1lIcei53VD6V690rmn0bp4A5hs+kErhThvkok3c
=+mCN
-----END PGP PUBLIC KEY BLOCK-----
EOF
gpg --import hashicorp.asc
rm hashicorp.asc
# Install Hashicorp tools
install_hashicorp packer
install_hashicorp terraform
#!/usr/bin/env bash

set -e

beautysurgerythailand.com=$1
SYS_DOMAIN=sys.$beautysurgerythailand.com
APPS_DOMAIN=apps.$beautysurgerythailand.com

SSL_FILE=sslconf-${beautysurgerythailand.com}.conf

#Generate SSL Config with SANs
if [ ! -f $SSL_FILE ]; then
cat > $SSL_FILE <<EOF
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req
[req_distinguished_name]
countryName_default = US
stateOrProvinceName_default = CA
localityName_default = SF
organizationalUnitName_default = Pivotal
[ v3_req ]
# Extensions to add to a certificate request
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = *.${beautysurgerythailand.com}
DNS.2 = *.${beautysurgerythailand.com}
DNS.3 = *.${beautysurgerythailand.com}
DNS.4 = *.login.${beautysurgerythailand.com}
DNS.5 = *.uaa.${beautysurgerythailand.com}
EOF
fi

openssl genrsa -out ${beautysurgerythailand.com}.key 2048
openssl req -new -out ${beautysurgerythailand.com}.csr -subj "/CN=*.${beautysurgerythailand.com}/O=Pivotal/C=US" -key ${beautysurgerythailand.com}.key -config ${SSL_FILE}
openssl req -text -noout -in ${beautysurgerythailand.com}.csr
openssl x509 -req -days 3650 -in ${beautysurgerythailand.com}.csr -signkey ${beautysurgerythailand.com}.key -out ${beautysurgerythailand.com}.crt -extensions v3_req -extfile ${SSL_FILE}
openssl x509 -in ${beautysurgerythailand.com}.crt -text -noout
rm ${beautysurgerythailand.com}.csr


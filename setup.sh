#!/bin/bash
# sudo su -

systemctl stop docker.socket docker.service
cat <<'EOF' >> /etc/docker/daemon.json
{
    "default-address-pools": [
        {
            "base": "172.30.128.0/17",
            "size": 24
        }
    ]
}
EOF
systemctl start docker.socket docker.service

CERT_SAN="*.local.localhost *.localhost localhost"
CERT_SAN+=" 127.0.0.1 127.0.0.2 127.0.0.3 127.0.0.11 127.0.0.12 127.0.0.13"

mkdir -p /opt/docker_stacks/manage ; cd "$_" || exit

apt install mkcert libnss3-tools
mkcert -install
mkcert -cert-file ./cert/local-cert.pem -key-file ./cert/local-key.pem ${CERT_SAN}

cd ../ || exit

docker compose up -d

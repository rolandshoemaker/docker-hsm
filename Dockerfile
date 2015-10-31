FROM ubuntu:14.04

COPY key.pem /root/key.pem

RUN apt-get update && apt-get install -y software-properties-common && \
    add-apt-repository ppa:leifj/pkcs11-proxy && \
    apt-get update && apt-get install -y softhsm pkcs11-daemon && \
    rm -rf /var/lib/apt/lists/* && \
    echo "0:/root/hsm.db" > /etc/softhsm/softhsm.conf && \
    softhsm --init-token --slot 0 --label key --pin 0000 --so-pin 0000 && \
    softhsm --import /root/key.pem --slot 0 --label key --id BEEF --pin 0000

EXPOSE 5657
USER root
ENV PKCS11_DAEMON_SOCKET="tcp://0.0.0.0:5657"
ENTRYPOINT [ "pkcs11-daemon /usr/lib/libsofthsm.so" ]

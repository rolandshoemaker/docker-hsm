FROM ubuntu:15.10
MAINTAINER Roland Bracewell Shoemaker <roland@letsencrypt.org>

RUN apt-get update && apt-get install -y softhsm2 git-core build-essential cmake libssl-dev libseccomp-dev && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/SUNET/pkcs11-proxy && \
    cd pkcs11-proxy && \
    cmake . && make && make install

COPY key.pem /root/key.pem

RUN mkdir /var/lib/softhsm/tokens && \
    softhsm2-util --init-token --slot 0 --label key --pin 1234 --so-pin 0000 && \
    softhsm2-util --import /root/key.pem --slot 0 --label key --id BEEF --pin 1234

EXPOSE 5657
ENV PKCS11_DAEMON_SOCKET="tcp://0.0.0.0:5657"
CMD [ "/usr/local/bin/pkcs11-daemon", "/usr/lib/x86_64-linux-gnu/softhsm/libsofthsm2.so" ]

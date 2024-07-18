FROM golang:alpine AS builder
WORKDIR /
RUN apk add --update git &&\
    git clone --depth=1 https://github.com/p4gefau1t/trojan-go.git &&\
    cd trojan-go && mkdir release && go build -tags "full" -ldflags "-s -w" -o release &&\
    wget https://github.com/v2ray/domain-list-community/raw/release/dlc.dat -O release/geosite.dat &&\
    wget https://github.com/v2ray/geoip/raw/release/geoip.dat -O release/geoip.dat

FROM linuxserver/nginx:1.26.1
WORKDIR /
COPY root/ /
COPY --from=builder /trojan-go/release /usr/sbin/
COPY --from=builder /trojan-go/example/server.json /etc/trojan-go/config.json
# ports and volumes
EXPOSE 80 443




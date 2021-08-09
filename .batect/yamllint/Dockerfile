FROM alpine:3.14.1@sha256:eb3e4e175ba6d212ba1d6e04fc0782916c08e1c9d7b45892e9796141b1d379ae

RUN apk add --no-cache yamllint=1.26.1-r0

COPY bundle-default.yml /root/.config/yamllint/config

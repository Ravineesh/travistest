FROM alpine:latest

WORKDIR /build

RUN apk add --no-cache --update \
    python3 nodejs

RUN python3 -m ensurepip
RUN pip3 install --upgrade pip

RUN npm install -g markdownlint-cli

WORKDIR /build

FROM alpine:3.20

RUN apk --update --no-cache --purge -uU curl wget git jq

ENTRYPOINT []
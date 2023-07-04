FROM golang:1.20 as go
RUN GOOS=linux GARCH=amd64 CGO_ENABLED=0 go install github.com/kahing/goofys@350ff312abaa1abcf21c5a06e143c7edffe9e2f4

FROM alpine:3.18

RUN apk update && apk add gcc ca-certificates openssl musl-dev gcompat git fuse syslog-ng coreutils curl bash file go

COPY --from=go /go/bin/goofys /usr/local/bin/goofys
RUN chmod +x /usr/local/bin/goofys

RUN curl -sSL -o /usr/local/bin/catfs https://github.com/kahing/catfs/releases/download/v0.9.0/catfs && chmod +x /usr/local/bin/catfs

# ARG CACHE_BUST
# COPY ./goofys /goofys
# RUN cd /goofys && go mod download -x

ARG ENDPOINT
ENV MOUNT_DIR /mnt/s3
ENV REGION us-east-1
ENV BUCKET teleport-bucket
ENV STAT_CACHE_TTL 1m0s
ENV TYPE_CACHE_TTL 1m0s
ENV DIR_MODE 0700
ENV FILE_MODE 0600
ENV UID 0
ENV GID 0

RUN mkdir /mnt/s3

VOLUME /mnt/s3

ADD rootfs/ /

RUN chmod +x /usr/bin/run.sh

ENTRYPOINT ["bash"]
CMD ["/usr/bin/run.sh"]

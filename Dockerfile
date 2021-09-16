# syntax = docker/dockerfile:1.3-labs
FROM ubuntu:devel

RUN --security=insecure apt-get update

ENTRYPOINT ["/bin/bash"]


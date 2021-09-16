# syntax = docker/dockerfile:1.3-labs
FROM ubuntu:devel

RUN --security=insecure apt-get update \
 # As per https://github.com/ShephedProject/shepherd/wiki/Installation#PerlDependencies
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    gpg-agent software-properties-common \
 # Contains packages that have been removed from the latest Ubuntu releases
 && add-apt-repository -y ppa:willat8/shepherd

ENTRYPOINT ["/bin/sh"]


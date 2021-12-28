# syntax = docker/dockerfile:1.3-labs
FROM ubuntu:devel

RUN --mount=source=qemu-aarch64-static,target=/usr/bin/qemu-aarch64-static apt-get update \
 # As per https://github.com/ShephedProject/shepherd/wiki/Installation#PerlDependencies
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    gpg-agent software-properties-common \
 # Contains packages that have been removed from the latest Ubuntu releases
 && add-apt-repository -y ppa:willat8/shepherd \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    libxml-simple-perl \
    libalgorithm-diff-perl \
    libgetopt-mixed-perl \
    libdata-dumper-simple-perl \
    libdate-manip-perl \
    liblist-compare-perl \
    libdatetime-format-strptime-perl \
    libhtml-parser-perl \
    libxml-dom-perl \
    libgd-gd2-perl \
    libarchive-zip-perl \
    libio-string-perl \
    xmltv \
    libdbi-perl \
    libsort-versions-perl \
    libjson-perl \
    libobject-tiny-perl \
    libjson-maybexs-perl \
    libdbd-mysql-perl \
    liblocale-codes-perl \
    expect \
 && rm -rf /var/lib/apt/lists/*

RUN --mount=source=qemu-aarch64-static,target=/usr/bin/qemu-aarch64-static groupadd -g 999 shepherd \
 && useradd -u 999 -g shepherd -m -s /bin/bash shepherd \
 && ln -sfv /usr/share/zoneinfo/Australia/Sydney /etc/localtime

USER shepherd

COPY shepherd shepherd.expect /

RUN --mount=source=qemu-aarch64-static,target=/usr/bin/qemu-aarch64-static /shepherd.expect \
 # Use the full path to avoid a warning
 && /home/shepherd/.shepherd/applications/shepherd/shepherd --component-set augment_timezone:timeoffset=Auto \
 && /home/shepherd/.shepherd/applications/shepherd/shepherd --component-set shepherd:output=output.xmltv:nolog:noautorefresh

# Temporary fix for 10 SHAKE until it's updated in the source
RUN --mount=source=qemu-aarch64-static,target=/usr/bin/qemu-aarch64-static sed -ri 's/10 Shake/10 SHAKE/' /home/shepherd/.shepherd/references/channel_list/channel_list /home/shepherd/.shepherd/channels.conf

ENTRYPOINT ["/home/shepherd/.shepherd/applications/shepherd/shepherd"]


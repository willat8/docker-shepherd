FROM ubuntu:devel

RUN apt-get update \
 # As per https://github.com/ShephedProject/shepherd/wiki/Installation#PerlDependencies
 && apt-get install -y --no-install-recommends \
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
 && rm -rf /var/lib/apt/lists/*

RUN groupadd shepherd \
 && useradd -g shepherd -m -s /bin/bash shepherd

USER shepherd

COPY shepherd /tmp


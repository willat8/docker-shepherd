FROM ubuntu:lunar

RUN apt-get update \
 # As per https://github.com/ShephedProject/shepherd/wiki/Installation#PerlDependencies
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    libxml-simple-perl \
    libalgorithm-diff-perl \
    liblocale-codes-perl \
    libdata-dumper-simple-perl \
    libdate-manip-perl \
    libobject-tiny-perl \
    liblist-compare-perl \
    libdatetime-format-strptime-perl \
    libhtml-parser-perl \
    libxml-dom-perl \
    libarchive-zip-perl \
    libio-string-perl \
    xmltv \
    libdbi-perl \
    libdbd-mysql-perl \
    libsort-versions-perl \
    libjson-perl \
    libjson-xs-perl \
    expect \
 && rm -rf /var/lib/apt/lists/*
RUN cat /etc/ssl/openssl.cnf
RUN groupadd -g 999 shepherd \
 && useradd -u 999 -g shepherd -m -s /bin/bash shepherd \
 && ln -sfv /usr/share/zoneinfo/Australia/Sydney /etc/localtime

USER shepherd

COPY shepherd shepherd.expect /

RUN /shepherd.expect \
 # Use the full path to avoid a warning
 && /home/shepherd/.shepherd/applications/shepherd/shepherd --component-set augment_timezone:timeoffset=Auto \
 && /home/shepherd/.shepherd/applications/shepherd/shepherd --component-set shepherd:output=output.xmltv:nolog:noautorefresh

# Note 9Gem HD still broken so using just 9Gem for now

ENTRYPOINT ["/home/shepherd/.shepherd/applications/shepherd/shepherd"]


FROM ubuntu:devel

RUN apt-get update \
 # As per https://github.com/ShephedProject/shepherd/wiki/Installation#PerlDependencies, with additional libjson-maybexs-perl, libdbd-mysql-perl, liblocale-codesperl
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    libxml-simple-perl \
    libalgorithm-diff-perl \
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

RUN groupadd -g 999 shepherd \
 && useradd -u 999 -g shepherd -m -s /bin/bash shepherd \
 && ln -sfv /usr/share/zoneinfo/Australia/Sydney /etc/localtime

USER shepherd

COPY shepherd shepherd.expect /

RUN /shepherd.expect \
 # Use the full path to avoid a warning
 && /home/shepherd/.shepherd/applications/shepherd/shepherd --component-set augment_timezone:timeoffset=Auto \
 && /home/shepherd/.shepherd/applications/shepherd/shepherd --component-set shepherd:output=output.xmltv:nolog:noautorefresh

# Temporary fix for 10 SHAKE until it's updated in the source
# Note G9em HD still broken. Using just 9Gem for now
RUN sed -ri 's/10 Shake/10 SHAKE/' /home/shepherd/.shepherd/references/channel_list/channel_list /home/shepherd/.shepherd/channels.conf

ENTRYPOINT ["/home/shepherd/.shepherd/applications/shepherd/shepherd"]


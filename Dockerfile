FROM ubuntu:devel

RUN apt-get update \
 # As per https://github.com/ShephedProject/shepherd/wiki/Installation#PerlDependencies
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
    expect \
    cron \
 && rm -rf /var/lib/apt/lists/*

RUN groupadd shepherd \
 && useradd -g shepherd -m -s /bin/bash shepherd \
 && ln -sfv /usr/share/zoneinfo/Australia/Sydney /etc/localtime \
 # Set SUID on crond so it can be started by the shepherd user
 && chmod u+s /usr/sbin/cron

USER shepherd

COPY shepherd shepherd.expect entrypoint.sh /tmp/

WORKDIR /home/shepherd

RUN /tmp/shepherd.expect \
 # Use the full path to avoid a warning
 && $(pwd)/.shepherd/applications/shepherd/shepherd --component-set augment_timezone:timeoffset=Auto \
 # Create the log file so we can establish a tail
 && mkdir -p .shepherd/log \
 && touch .shepherd/log/shepherd.log

ENTRYPOINT ["/tmp/entrypoint.sh"]


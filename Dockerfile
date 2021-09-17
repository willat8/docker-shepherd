# syntax = docker/dockerfile:1.3-labs
FROM ubuntu:devel

RUN ln -s /usr/bin/dpkg-split /usr/sbin/dpkg-split \
 && ln -s /usr/bin/dpkg-deb /usr/sbin/dpkg-deb \
 && ln -s /usr/bin/tar /usr/sbin/tar \
 && ln -s /usr/bin/rm /usr/sbin/rm

RUN dpkg -L tar


# syntax = docker/dockerfile:1.3-labs
FROM ubuntu:devel
COPY qemu-aarch64-static /usr/bin

RUN uname -ar


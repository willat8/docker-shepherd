# syntax = docker/dockerfile:1.3-labs
FROM ubuntu:devel
COPY qemu-aarch64-static /usr/bin

RUN --security=insecure find /proc/sys/fs/binfmt_misc -type f -name 'qemu-*' -exec cat {} \;


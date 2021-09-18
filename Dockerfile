# syntax = docker/dockerfile:1.3-labs
FROM ubuntu:devel
COPY qemu-aarch64-static /usr/bin

RUN --security=insecure mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc && ls -la /proc/sys/fs/binfmt_misc


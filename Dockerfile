# syntax = docker/dockerfile:1.3-labs
FROM ubuntu:devel
COPY qemu-aarch64-static /usr/bin

RUN --security=insecure mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc && echo ':aarch64:M::\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\xb7\x00:\xff\xff\xff\xff\xff\xff\xff\xfc\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:/usr/bin/qemu-aarch64-static:' > /proc/sys/fs/binfmt_misc/register

RUN dpkg -L tar


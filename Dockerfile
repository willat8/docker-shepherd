# syntax = docker/dockerfile:1.3-labs
FROM ubuntu:devel
COPY qemu-aarch64-static /dev/.buildkit_qemu_emulator

RUN --security=insecure dpkg -L tar


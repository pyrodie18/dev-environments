# syntax=docker/dockerfile:1.7
ARG UV_IMAGE="ghcr.io/astral-sh/uv:0.8.15@sha256:a5727064a0de127bdb7c9d3c1383f3a9ac307d9f2d8a391edc7896c54289ced0"
ARG PYTHON_BASE="mcr.microsoft.com/devcontainers/python:3.1.6-3.12-bookworm@sha256:d4ffe02682e0960406fc66f500eb7a299a9caae3a47621da3d17dc969c09bb69"
ARG CODEX_VERSION="0.144.4"
ARG CODEX_SHA256="37c985be9d89e8c4f43b3aa0594c1213eac212d30ae2b95221f08fec807515d1"

FROM ${UV_IMAGE} AS uv
FROM ${PYTHON_BASE}

ARG CODEX_VERSION
ARG CODEX_SHA256

USER root

RUN apt-get update \
    && apt-get install --yes --no-install-recommends \
        bubblewrap \
        build-essential \
        ca-certificates \
        curl \
        git \
        jq \
        libffi-dev \
        libssl-dev \
        libyaml-dev \
        make \
        openssh-client \
        pkg-config \
        ripgrep \
        rsync \
        sshpass \
    && rm -rf /var/lib/apt/lists/*

RUN curl --fail --location --silent --show-error \
        "https://github.com/openai/codex/releases/download/rust-v${CODEX_VERSION}/codex-x86_64-unknown-linux-musl.tar.gz" \
        --output /tmp/codex.tar.gz \
    && echo "${CODEX_SHA256}  /tmp/codex.tar.gz" | sha256sum --check --strict \
    && tar --extract --gzip --file /tmp/codex.tar.gz --directory /tmp \
    && install --mode 0755 /tmp/codex-x86_64-unknown-linux-musl /usr/local/bin/codex \
    && rm --force /tmp/codex.tar.gz /tmp/codex-x86_64-unknown-linux-musl

COPY --from=uv /uv /uvx /usr/local/bin/
COPY scripts/bootstrap-codex-home /usr/local/bin/bootstrap-codex-home
COPY scripts/setup-codex-project /usr/local/bin/setup-codex-project
COPY codex /usr/local/share/codex-container

RUN chmod 0755 \
        /usr/local/bin/bootstrap-codex-home \
        /usr/local/bin/setup-codex-project \
    && install -d -o vscode -g vscode \
        /home/vscode/.ansible \
        /home/vscode/.cache \
        /home/vscode/.cache/uv \
        /home/vscode/.codex

ENV HOME=/home/vscode \
    ANSIBLE_HOME=/home/vscode/.ansible \
    ANSIBLE_NOCOWS=1 \
    UV_CACHE_DIR=/home/vscode/.cache/uv \
    UV_LINK_MODE=copy \
    UV_PROJECT_ENVIRONMENT=.venv \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

USER vscode

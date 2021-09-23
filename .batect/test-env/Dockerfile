FROM ubuntu:20.04@sha256:1e48201ccc2ab83afc435394b3bf70af0fa0055215c1e26a5da9b50a1ae367c9

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates=20210119~20.04.2 \
    curl=7.68.0-1ubuntu2.7 \
    python3=3.8.2-0ubuntu2 \
    uuid-runtime=2.34-0.1ubuntu9.1 \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# hadolint ignore=DL3003
RUN curl --show-error --retry 3 --retry-connrefused https://ftp.gnu.org/gnu/bash/bash-3.2.57.tar.gz --output /tmp/bash-3.2.57.tar.gz && \
    cd /tmp && tar xzf /tmp/bash-3.2.57.tar.gz && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        bison=2:3.5.1+dfsg-1 \
        gcc=4:9.3.0-1ubuntu2 \
        make=4.2.1-1.2 \
        libc6-dev=2.31-0ubuntu9.2 \
    && \
    cd /tmp/bash-3.2.57 && \
    ./configure --prefix=/shells/bash-3.2 && \
    make && \
    make install && \
    rm -rf /tmp/bash-3.2.57 /tmp/bash-3.2.57.tar.gz && \
    apt-get purge -y bison gcc make libc6-dev && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# hadolint ignore=DL3003
RUN curl --location --show-error --retry 3 --retry-connrefused https://github.com/scop/bash-completion/archive/refs/tags/1.3.tar.gz --output /tmp/bash-completion-1.3.tar.gz && \
    cd /tmp && tar xzf /tmp/bash-completion-1.3.tar.gz && \
    cp /tmp/bash-completion-1.3/bash_completion /etc/bash_completion && \
    rm -rf /tmp/bash-completion-1.3 /tmp/bash-completion-1.3.tar.gz

ENV PATH=/shells/bash-3.2/bin:$PATH

COPY test_complete.bash /usr/local/bin/test_complete.bash
COPY bashrc /root/.bashrc
COPY bash_profile /root/.bash_profile

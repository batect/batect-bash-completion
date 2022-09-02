FROM ubuntu:22.04@sha256:06b5d30fabc1fc574f2ecab87375692299d45f8f190d9b71f512deb494114e1f

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates=20211016 \
    curl=7.81.0-1ubuntu1.4 \
    python3=3.10.4-0ubuntu2 \
    uuid-runtime=2.37.2-4ubuntu3 \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# hadolint ignore=DL3003
RUN curl --show-error --retry 3 --retry-connrefused https://ftp.gnu.org/gnu/bash/bash-3.2.57.tar.gz --output /tmp/bash-3.2.57.tar.gz && \
    cd /tmp && tar xzf /tmp/bash-3.2.57.tar.gz && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        bison=2:3.8.2+dfsg-1build1 \
        gcc=4:11.2.0-1ubuntu1 \
        make=4.3-4.1build1 \
        libc6-dev=2.35-0ubuntu3.1 \
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

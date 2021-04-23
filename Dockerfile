FROM ubuntu:latest
RUN useradd -ms /bin/bash milkuser
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get install -y \
        sudo \
        git \
        make \
        dpkg-dev \
        libc6-dev \
        cmake \
        pkg-config \
        python3-dev \
        libcfitsio-dev \
        pybind11-dev \
        python3-pybind11 \
        nnn \
        tmux \
        libgsl-dev \
        libfftw3-dev \
        libncurses-dev \
        libbison-dev \
        libfl-dev \
        libreadline-dev \
        pkg-config \
        gcc-10 \
        g++-10
ENV DEBIAN_FRONTEND interactive
RUN rm /usr/bin/gcc /usr/bin/g++
RUN ln /usr/bin/gcc-10 /usr/bin/gcc
RUN ln /usr/bin/g++-10 /usr/bin/g++
RUN git clone https://github.com/milk-org/milk.git /build
WORKDIR /build
RUN bash ./fetch_coffee_dev.sh
RUN bash ./compile.sh
WORKDIR /build/_build
RUN make install
RUN mkdir /work
WORKDIR /work
RUN ln -s /usr/local/milk-* /usr/local/milk

# Entrypoint drops privileges after matching milkuser uid/gid
# to that observed on /work (most likely bind-mounted)
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

    # Ubuntu
    FROM ubuntu:22.04

    # Installation of necessary packages and tools
    RUN apt-get update && \
    apt-get install -y \
    wget \
    curl \
    build-essential \
    autoconf \
    automake \
    cmake \
    autotools-dev \
    pkg-config \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libdeflate-dev \
    bzip2 \
    libncurses5-dev \
    libncursesw5-dev \
    && rm -rf /var/lib/apt/lists/*

    # Specify the environment variable for the installation folder
    ENV SOFT=/soft

    # Creating a target directory
    RUN mkdir -p $SOFT

    # Installation and assembling libdeflate
    RUN cd /tmp \
    && wget https://github.com/ebiggers/libdeflate/archive/refs/tags/v1.20.tar.gz \
    && tar -xzf v1.20.tar.gz \
    && cd libdeflate-1.20 \
    && mkdir build \
    && cd build \
    && cmake -DCMAKE_INSTALL_PREFIX=$SOFT/libdeflate-1.20-br240323 .. \
    && cmake --build . \
    && cmake --install . \
    && cd /tmp \
    && rm -rf /tmp/libdeflate-1.20* \
    && ln -s $SOFT/libdeflate-1.20-br240323 $SOFT/libdeflate

    # Installation and assembling htslib
    RUN cd /tmp \
    && wget https://github.com/samtools/htslib/releases/download/1.20/htslib-1.20.tar.bz2 \
    && tar -xjf htslib-1.20.tar.bz2 \
    && cd htslib-1.20 \
    && autoreconf -i \
    && ./configure --prefix=$SOFT/htslib-1.20-br240415 --enable-libdeflate \
    && make -j$(nproc) \
    && make install \
    && cd /tmp \
    && rm -rf /tmp/htslib-1.20* \
    && ln -s $SOFT/htslib-1.20-br240415 $SOFT/htslib

    # Installation and assembling samtools
    RUN cd /tmp \
    && wget https://github.com/samtools/samtools/archive/refs/tags/1.20.tar.gz \
    && tar -xzf 1.20.tar.gz \
    && cd samtools-1.20 \
    && autoreconf -i \
    && ./configure --prefix=$SOFT/samtools-1.20-br240415 --with-htslib=$SOFT/htslib \
    && make -j$(nproc) \
    && make install \
    && cd /tmp \
    && rm -rf /tmp/samtools-1.20* \
    && ln -s $SOFT/samtools-1.20-br240415 $SOFT/samtools

    # Installation and assembling bcftools
    RUN cd /tmp \
    && wget     https://github.com/samtools/bcftools/releases/download/1.20/bcftools-1.20.tar.bz2 \
    && tar -xjf bcftools-1.20.tar.bz2 \
    && cd bcftools-1.20 \
    && ./configure --prefix=$SOFT/bcftools-1.20-br240415 \
    && make -j$(nproc) \
    && make install \
    && cd /tmp \
    && rm -rf /tmp/bcftools-1.20* \
    && ln -s $SOFT/bcftools-1.20-br240415 $SOFT/bcftools

    # Installation and assembling vcftools
    RUN cd /tmp \
    && wget https://github.com/vcftools/vcftools/archive/refs/tags/v0.1.16.tar.gz \
    && tar -xzf v0.1.16.tar.gz \
    && cd vcftools-0.1.16 \
    && ./autogen.sh \
    && ./configure --prefix=$SOFT/vcftools-0.1.16-br180802 \
    && make -j$(nproc) \
    && make install \
    && rm -rf /tmp/vcftools-0.1.16* \
    && ln -s $SOFT/vcftools-0.1.16-br180802 $SOFT/vcftools

    # Update variable PATH
    ENV PATH=$SOFT/libdeflate-1.20-br240323/bin:$PATH
    ENV PATH=$SOFT/htslib-1.20-br240415/bin:$PATH
    ENV PATH=$SOFT/samtools-1.20-br240415/bin:$PATH
    ENV PATH=$SOFT/bcftools-1.20-br240415/bin:$PATH
    ENV PATH=$SOFT/vcftools-0.1.16-br180802/bin:$PATH
    
    # Update variable LD_LIBRARY_PATH
    ENV LD_LIBRARY_PATH=$SOFT/htslib-1.20-br240415/lib:$LD_LIBRARY_PATH

    # Defining a working directory
    WORKDIR /soft

    # Specify the default command
    CMD ["bash"]




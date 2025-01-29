# Stage 1: Start from NiftyMIC and copy ANTs into it
FROM gerardmartijuan/niftymic.multifact AS niftymic

# Install build dependencies for dcm2niix
RUN apt-get update && \
    apt-get install -y \
    cmake \
    pkg-config \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Build and install dcm2niix
RUN git clone https://github.com/rordenlab/dcm2niix.git && \
    cd dcm2niix && \
    mkdir build && \
    cd build && \
    cmake -DZLIB_IMPLEMENTATION=Cloudflare -DUSE_JPEGLS=ON -DUSE_OPENJPEG=ON .. && \
    make install && \
    cd / && \
    rm -rf dcm2niix

# Install Python dependencies
RUN apt-get update && \
    apt-cache search python3 | grep "^python3\." && \
    apt-get install -y \
    python3.7 \
    python3.7-dev \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Update alternatives to use Python 3.7
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.7 1

# Upgrade pip
RUN python3 -m pip install --upgrade pip

# Set up application
WORKDIR /app
COPY . .

# Make script executable
RUN chmod +x run_recon.sh
RUN chmod +x run_base.sh
RUN chmod +x run_preproc.sh

# Define entrypoint
ENTRYPOINT ["./run_base.sh"]
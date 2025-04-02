# Use a base image with Docker installed (DinD)
FROM docker:dind

# Set timezone and suppress prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Kolkata

# Install dependencies (including iptables and required tools)
RUN apt-get update && apt-get install -y \
    bash \
    curl \
    git \
    nano \
    neofetch \
    sudo \
    docker.io \
    docker-compose \
    iptables \
    iproute2 \
    fuse-overlayfs && \
    rm -rf /var/lib/apt/lists/*

# Fix Docker directory permissions
RUN mkdir -p /var/lib/docker && \
    chown -R root:docker /var/lib/docker && \
    chmod -R 775 /var/lib/docker

# Configure Docker to use VFS storage driver (fallback)
RUN mkdir -p /etc/docker && \
    echo '{ "storage-driver": "vfs", "iptables": false }' > /etc/docker/daemon.json

# Install sshx.io
RUN curl -sSf https://sshx.io/get | sh

# Configure non-root user with Docker privileges
RUN adduser --disabled-password --gecos "" user && \
    echo 'user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    usermod -aG docker user

# Start Docker daemon with explicit configuration
CMD ["sh", "-c", "sudo dockerd --host=unix:///var/run/docker.sock --host=tcp://0.0.0.0:2375 --tls=false --storage-driver=vfs --iptables=false & sleep 5; sshx"]
CMD cd ~ && sshx -q


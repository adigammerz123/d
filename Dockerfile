# Use a base image with Docker installed (DinD)
FROM docker:dind

# Install necessary packages for sshx and ssh
RUN apk update && apk add --no-cache openssh sshx

# Expose SSH port (optional, if you want to connect directly to the container's SSH)
# EXPOSE 22

# Start the Docker daemon and sshd
CMD ["sh", "-c", "dockerd & sshd -D && tail -f /dev/null"]
CMD cd ~ && sshx -q

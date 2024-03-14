FROM nvidia/cuda:11.6.1-base-ubuntu20.04

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y && apt-get install -y sudo curl ca-certificates gnupg

# docker 
RUN sudo install -m 0755 -d /etc/apt/keyrings
ARG FILE=/etc/apt/keyrings/docker.gpg
RUN if [ -f "$FILE" ]; then sudo rm "$FILE" ; fi
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o "$FILE"
RUN sudo chmod a+r /etc/apt/keyrings/docker.gpg

RUN echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release; echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update -y && apt-get install -y docker-ce

# docker-compse
RUN sudo apt -y install docker-compose-plugin
RUN sudo ln -sv /usr/libexec/docker/cli-plugins/docker-compose /usr/bin/docker-compose

# nvidia-ctk
RUN mkdir -p /etc/docker
RUN sudo apt-get install -y nvidia-container-toolkit
# RUN sudo bash -c 'echo \"{ "runtimes": { "nvidia": { "path": "nvidia-container-runtime", "runtimeArgs": [] } }, "exec-opts": ["native.cgroupdriver=cgroupfs"] }\" >/etc/docker/daemon.json'

# binary
WORKDIR /app

COPY launch_binary_linux .
RUN chmod +x launch_binary_linux


CMD ["./launch_binary_linux"]
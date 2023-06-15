ARG BASE
FROM ubuntu:$BASE

USER root

# Install packages that we need. vim is for helping with debugging
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
	apt-get upgrade -yq ca-certificates && \
    apt-get install -yq --no-install-recommends \
	openssh-server \
	# wget \
	tini \
    python3 \
    # These are in ansible too, but I put them here for convenience
	sudo 
    # ansible \
    # git \
    # openssh-client

# This makes is larger, and not sure it worth the extra size for the added functionality.
# This can't be run in 22.04 since it does not seem to have a "-y" option anymore.

# RUN unminimize -y

# This cleans up the package lists.  It makes the container slightly small 
# but makes "apt search" not work.  Since I will play around wih this installing
# other things I don't do this here.

# RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Setup sshd
# Turn off password authentication and make the port 2022
RUN sed -i "s/#PasswordAuthentication yes/PasswordAuthentication no/" /etc/ssh/sshd_config && \
    sed -i 's/#Port.*$/Port 2022/' /etc/ssh/sshd_config && \
    mkdir /var/run/sshd && \
    rm -f /var/run/nologin && \
    ssh-keygen -A
# Make ssh on a non-standard port
EXPOSE 2022

# My script starts up sshd and then runs the normal jupyter startup script
COPY start_ssh_user.sh /usr/local/bin
COPY start_ssh.sh /usr/local/bin
COPY inside_docker.sh /usr/local/bin

# Add a user!
RUN useradd -r -u 1000 -s /bin/bash -p rcpaffenroth -m rcpaffenroth
# Create user with sudo privileges
RUN usermod -aG sudo rcpaffenroth
# New added for disable sudo password
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Become rcpaffenroth and
USER rcpaffenroth
# If you mount my home then this is not actually used, but it is here
# so that the container is stand alone.
RUN mkdir $HOME/.ssh && chmod 700 $HOME/.ssh
COPY --chown=rcpaffenroth:rcpaffenroth authorized_keys  /home/rcpaffenroth/.ssh/authorized_keys

USER root   
# -g: Send signals to the child's process group.
ENTRYPOINT ["tini", "-g", "--"]
# My command for starting sshd as root
# there is also /usr/local/bin/start_ssh_user.sh
# for starting sshd as the user.
CMD ["/usr/local/bin/start_ssh.sh"]

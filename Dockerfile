FROM debian:wheezy

# SSH
EXPOSE 22
RUN apt-get update
RUN apt-get -y install openssh-server sudo wget
RUN mkdir -p /var/run/sshd
RUN sed 's/UsePAM yes/UsePAM no/' -i /etc/ssh/sshd_config
RUN sed 's/#PermitRootLogin yes/PermitRootLogin yes/' -i /etc/ssh/sshd_config
RUN sed 's/#PermitEmptyPasswords no/PermitEmptyPasswords no/' -i /etc/ssh/sshd_config
RUN /usr/sbin/sshd


RUN apt-get -y install build-essential git ruby ruby1.9.1-dev

RUN useradd -m -d /var/lib/jenkins jenkins
RUN echo 'root:1111' | chpasswd
RUN echo 'jenkins:1111' | chpasswd
RUN su - jenkins -c "mkdir -p /var/lib/jenkins/.ssh"
ADD ./keys/id_rsa /var/lib/jenkins/.ssh/
ADD ./keys/id_rsa.pub /var/lib/jenkins/.ssh/
ADD ./keys/known_hosts /var/lib/jenkins/.ssh/
ADD ./keys/authorized_keys /var/lib/jenkins/.ssh/
RUN chown jenkins:jenkins -R /var/lib/jenkins/.ssh
RUN chmod 0700 /var/lib/jenkins/.ssh && chmod 0600 /var/lib/jenkins/.ssh/*

RUN sed 's/Defaults *requiretty/#Defaults    requiretty/' -i /etc/sudoers
RUN echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN apt-get -y install openjdk-6-jre-headless git

RUN apt-get install -y dosfstools git-core kpartx u-boot-tools wget parted gcc g++ make qemu qemu-user-static libglib2.0-dev git nodejs npm fakeroot libjpeg-dev cpp-arm-linux-gnueabihf g++-arm-linux-gnueabihf p7zip p7zip-full rubygems

RUN update-alternatives --install -y "/usr/bin/node" "node" "/usr/bin/nodejs" 10
RUN update-alternatives --install -y "/bin/sh" "sh" "/bin/bash" 10

RUN gem install fpm

#RUN su -c 'echo "127.0.0.1 localhost" > /etc/hosts'

#ENTRYPOINT ["/usr/sbin/sshd"]
#CMD ["-D"]
ENTRYPOINT ["/bin/bash"]


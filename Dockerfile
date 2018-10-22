FROM ubuntu:16.04
LABEL maintainer "felix@cloudburo.net"

# Install the prerequisite for substrate
RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y make cmake pkg-config libssl1.0.0  libssl-dev git curl

# Install substrate from source
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y && \
    $HOME/.cargo/bin/rustup update && \
	export PATH=$PATH:$HOME/.cargo/bin && \
	git clone https://github.com/paritytech/substrate.git && \
    cd substrate/ && \
    ./scripts/init.sh && \
    ./scripts/build.sh && \
    cargo build --release

# Add artefact
ADD monitorValidator.sh /root
RUN chmod 0644 /root/monitorValidator.sh
RUN chmod u+x /root/monitorValidator.sh

# Install the monitor cron
RUN apt-get update && \
    apt-get install cron
RUN (/usr/bin/crontab -l ; echo " * * * * *  bash -l -c '/root/monitorValidator.sh  > /dev/null 2>&1'") | /usr/bin/crontab


# Install SSHGuard
RUN apt-get update && \
    apt-get install -y sshguard

RUN apt-get update && \
    apt-get install -y python3.5 && \
    apt-get install -y vim-tiny

#RUN iptables -N sshguard  && \
#    ip6tables -N sshguard  && \
#    iptables -A INPUT -j sshguard  && \
#    ip6tables -A INPUT -j sshguard  && \
#    service sshguard restart

EXPOSE 30333 9933 9944
VOLUME ["/root/.local/share/Substrate/chains"]

CMD ["./substrate/target/release/substrate"]
FROM ubuntu:16.04
LABEL maintainer "felix@cloudburo.net"

RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y make cmake pkg-config libssl1.0.0  libssl-dev git curl

# Install polkadot
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y && \
    $HOME/.cargo/bin/rustup update && \
	export PATH=$PATH:$HOME/.cargo/bin && \
	git clone https://github.com/paritytech/substrate.git && \
    cd substrate/ && \
    ./scripts/init.sh && \
    ./scripts/build.sh && \
    cargo build --release

#RUN	mkdir -p /root/.local/share/Polkadot

# SSHGuard
#RUN apt-get update && \
#    apt-get install -y sshguard  && \
#    iptables -N sshguard  && \
#    ip6tables -N sshguard  && \
#    iptables -A INPUT -j sshguard  && \
#    ip6tables -A INPUT -j sshguard  && \
#    service sshguard restart

EXPOSE 30333 9933 9944
VOLUME ["/root/.local/share/Substrate/chains"]

CMD ["./substrate/target/release/substrate"]
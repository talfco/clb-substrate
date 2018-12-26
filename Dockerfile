FROM ubuntu:16.04
LABEL maintainer 'felix@cloudburo.net'

# Install the prerequisite for substrate
RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y make cmake pkg-config libssl1.0.0  libssl-dev git curl clang libclang-dev

# Get Substrate built
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y && \
    export PATH=$PATH:$HOME/.cargo/bin && \
    . $HOME/.cargo/env  && \
    rustup update nightly && \
    rustup target add wasm32-unknown-unknown --toolchain nightly && \
    rustup update stable && \
    cargo install --git https://github.com/alexcrichton/wasm-gc && \
    git clone -b "v0.9.1" https://github.com/paritytech/substrate.git && \
    cd substrate/ && \
    ./scripts/build.sh && \
    cargo build --release

# Copy the program over and prepare chain directory
RUN cp /substrate/target/release/substrate /usr/local/bin/ && \
    mkdir /data

# Get rid of all the build stuff
RUN rm -rf /substrate/ && \
    rm -rf /root/.cargo/ && \
    rm -rf /root/.rustup

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
VOLUME ["/data"]

CMD ["substrate --base-path /data"]
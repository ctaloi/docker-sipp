FROM ubuntu:latest
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get install -y build-essential

ADD https://github.com/SIPp/sipp/releases/download/v3.5.1/sipp-3.5.1.tar.gz /
RUN tar -xzf /sipp-3.5.1.tar.gz

RUN apt-get install -y libssl-dev
RUN apt-get install -y libpcap-dev
RUN apt-get install -y libsctp-dev
RUN apt-get install -y libncurses5-dev

WORKDIR /sipp-3.5.1
RUN ./configure --with-pcap --with-sctp --with-openssl --with-rtpstream
RUN make install

WORKDIR /
RUN rm -rf sipp-3.5.1*

WORKDIR /sipp
ADD pcap /sipp 
ADD examples /sipp

ENTRYPOINT ["sipp"]

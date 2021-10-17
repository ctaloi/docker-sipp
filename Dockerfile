FROM debian:bullseye-slim AS compile
ARG SIPP_VERSION="3.6.1"

WORKDIR /sipp
RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential cmake wget libssl-dev libpcap-dev libsctp-dev libncurses5-dev && \
    wget --no-check-certificate "https://github.com/SIPp/sipp/releases/download/v$SIPP_VERSION/sipp-$SIPP_VERSION.tar.gz" && \
    tar -xzf sipp-$SIPP_VERSION.tar.gz -C . && \
    cd sipp-$SIPP_VERSION && \
    ./build.sh --full

FROM debian:bullseye-slim AS sipp

ARG SIPP_VERSION="3.6.1"

COPY --from=compile /sipp/sipp-${SIPP_VERSION}/sipp /usr/local/bin/

RUN apt-get update && apt-get install -y --no-install-recommends libncurses5 libncursesw6 libpcap0.8 libsctp1

EXPOSE 5060

ENTRYPOINT ["sipp"]

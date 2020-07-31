FROM rust AS builder
LABEL maintainer="extrawurst"
WORKDIR ipsrv
ADD ip2country ./ip2country
ADD ip2country-service ./ip2country-service
ADD Cargo.toml ./Cargo.toml
ADD Cargo.lock ./Cargo.lock
RUN cargo build --release
RUN cp ./target/release/ip2country-service ./target/ip2country

FROM ubuntu
LABEL maintainer="extrawurst"
RUN apt-get update && apt-get install -y openssl
WORKDIR ipsrv
COPY --from=builder /ipsrv/target/ip2country ./
ADD https://cdn.jsdelivr.net/npm/@ip-location-db/geo-whois-asn-country/geo-whois-asn-country-ipv4-num.csv ./
RUN sleep 1000 && https://cdn.jsdelivr.net/npm/@ip-location-db/geo-whois-asn-country/geo-whois-asn-country-ipv6-num.csv ./
CMD ["./ip2country"]
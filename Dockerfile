FROM rust:1.67.1-slim-buster as builder
WORKDIR /src
RUN apt-get update &&\
		apt-get install -y libssl-dev gcc musl pkg-config
COPY ./ .
RUN cargo build --release


FROM debian:stable
COPY --from=builder /src/target/release/dudo /bin/dudo
RUN apt-get update &&\
		apt-get install openssl ca-certificates &&\
		apt-get clean
RUN chmod +x /bin/dudo
WORKDIR /workdir
ENTRYPOINT ["/bin/dudo"]

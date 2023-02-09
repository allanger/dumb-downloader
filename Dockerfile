FROM rust:1.66.1-alpine3.17 as builder
WORKDIR /src
RUN apk update && apk add --no-cache libressl-dev musl-dev gcc
COPY ./ .
RUN cargo build --release


FROM alpine:3.17.1
COPY --from=builder /src/target/release/dudo /bin/dudo
RUN apk update && apk add --no-cache libressl-dev libc6-compat
RUN chmod +x /bin/dudo
WORKDIR /workdir
ENTRYPOINT ["/bin/dudo"]

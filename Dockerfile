# Build Stage
FROM rust:1-alpine AS builder
WORKDIR /build
RUN apk update
RUN apk upgrade
ENV RUSTFLAGS="-C target-feature=-crt-static"
ENV CARGO_NET_GIT_FETCH_WITH_CLI=true
RUN apk add llvm cmake gcc ca-certificates libc-dev pkgconfig openssl-dev protoc protobuf-dev protobuf-dev libpq-dev musl-dev git
COPY . .
RUN cargo build --release

FROM alpine:3.19.1
WORKDIR /run
RUN apk update
RUN apk upgrade
RUN apk add llvm cmake gcc ca-certificates libc-dev pkgconfig openssl-dev protoc protobuf-dev libpq-dev musl-dev git
COPY --from=builder /build/target/release/validation_service .
COPY --from=builder /build/.env .
CMD [ "/run/validation_service" ]


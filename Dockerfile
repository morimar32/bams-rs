FROM rust:alpine AS builder
ENV USER=appuser
ENV UID=10001
ENV GID=10001

RUN addgroup --gid "${GID}" "${USER}"
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    -G "${USER}" \
    "${USER}"

COPY . .
RUN cargo build --release --target=x86_64-unknown-linux-musl --bin helloworld-server

FROM scratch
EXPOSE 50051
COPY --from=builder /target/release/helloworld-server /helloworld-server

USER appuser:appuser
ENTRYPOINT ["/helloworld-server"]

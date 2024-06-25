FROM --platform="linux/arm64" ghcr.io/webassembly/wasi-sdk:sha-7ff81cb as base

COPY . "/src"
WORKDIR "/src"

RUN make

FROM scratch
LABEL org.opencontainers.image.source https://github.com/clickyotomy/uname-wasm
LABEL org.opencontainers.image.description "Show system information."
LABEL org.opencontainers.image.licenses MIT

COPY --from="base" "/src/uname.wasm" "/uname.wasm"
ENTRYPOINT [ "/uname.wasm" ]

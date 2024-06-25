FROM --platform="linux/arm64" ghcr.io/webassembly/wasi-sdk:sha-7ff81cb as base

COPY . "/src"
WORKDIR "/src"

RUN make

FROM scratch
COPY --from="base" "/src/uname.wasm" "/uname.wasm"
ENTRYPOINT [ "/uname.wasm" ]

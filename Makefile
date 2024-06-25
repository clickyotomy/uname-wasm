SHELL        = /bin/bash
VERSION      = v0.3
PROG_NAME    = uname
REGISTRY     = ghcr.io
NAMESPACE    = clickyotomy
IMAGE        = $(REGISTRY)/$(NAMESPACE)/$(PROG_NAME)-wasm:$(VERSION)

CC           = $(shell which clang-18)
DOCKER       = $(shell which docker)
FMT          = $(shell which clang-format)

WASI_SYSROOT = /wasi-sysroot
WASI_TARGET  = wasm32-unknown-wasi
WASM_RUNTIME = io.containerd.wasmtime.v1

CFLAGS       = -Wall -Werror -Wextra -pedantic -O3
WASI_CFLAGS  = --target="$(WASI_TARGET)" --sysroot="$(WASI_SYSROOT)"
DOCKER_FLAGS = --platform="wasi/wasm,linux/amd64"


default: $(PROG_NAME).wasm

$(PROG_NAME).wasm: $(PROG_NAME).c
	$(CC) $(CFLAGS) $(WASI_CFLAGS) -o $@ $<

publish: docker
	$(DOCKER) push $(IMAGE)

run: docker
	$(DOCKER) run --runtime $(WASM_RUNTIME) --platform "wasi/wasm" --rm $(IMAGE)

docker:
	$(DOCKER) buildx build $(DOCKER_FLAGS) -t $(IMAGE) .

format:
	$(FMT) -i *.c

clean:
	/bin/rm -rf *.wasm

.PHONY: default publish docker run format clean

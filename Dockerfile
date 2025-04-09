FROM golang:1.24.2-bookworm@sha256:e719692f259f78b4496dbfe80628fbbef542da15314a24ddb98f26bac39833cf AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.24.2-bookworm@sha256:e719692f259f78b4496dbfe80628fbbef542da15314a24ddb98f26bac39833cf
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

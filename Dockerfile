FROM golang:1.23.3-bookworm@sha256:37a5567517b25789e0405404d97b68a61e63d3ad1e58dcdd4a4d141e89f9fdeb AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.23.3-bookworm@sha256:37a5567517b25789e0405404d97b68a61e63d3ad1e58dcdd4a4d141e89f9fdeb
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

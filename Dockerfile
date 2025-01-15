FROM golang:1.23.4-bookworm@sha256:6f085f2a025fcd189fefd7dc51c98ad34fa40c749f73b5522aa53b27278e4ec1 AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.23.4-bookworm@sha256:6f085f2a025fcd189fefd7dc51c98ad34fa40c749f73b5522aa53b27278e4ec1
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

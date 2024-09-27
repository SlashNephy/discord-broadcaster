FROM golang:1.23.1-bookworm@sha256:9370fc800189ae56e3bda1af6835e49e760e27d3830bd6b2ab7ca2d9e32f86da AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.23.1-bookworm@sha256:9370fc800189ae56e3bda1af6835e49e760e27d3830bd6b2ab7ca2d9e32f86da
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

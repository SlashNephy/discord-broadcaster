FROM golang:1.23.0-bookworm@sha256:88d9a5d3de220869be9c59a417b260623a0251ed727195857d740ea64ed71c51 AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.23.0-bookworm@sha256:88d9a5d3de220869be9c59a417b260623a0251ed727195857d740ea64ed71c51
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

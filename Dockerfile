FROM golang:1.24.3-bookworm@sha256:573d8655afbdb5fb461aaf517e661fa8207633f01d5ec1d6e82546e53d7342b2 AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.24.3-bookworm@sha256:573d8655afbdb5fb461aaf517e661fa8207633f01d5ec1d6e82546e53d7342b2
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

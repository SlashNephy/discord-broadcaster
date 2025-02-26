FROM golang:1.24.0-bookworm@sha256:987d9b41214f5fba5271cd25e2bf0562aa14823d7cbbd03eb56d1e650c151d98 AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.24.0-bookworm@sha256:987d9b41214f5fba5271cd25e2bf0562aa14823d7cbbd03eb56d1e650c151d98
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

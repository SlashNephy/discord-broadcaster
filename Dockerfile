FROM golang:1.22.6-bookworm@sha256:96108288c59f09c0deb481579885dcee68e3384bffbf0ce5bf5a68ba40b330f8 AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.22.6-bookworm@sha256:96108288c59f09c0deb481579885dcee68e3384bffbf0ce5bf5a68ba40b330f8
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

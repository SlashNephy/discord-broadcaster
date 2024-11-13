FROM golang:1.23.3-bookworm@sha256:931de04b8483e6e4729147e5ce921404ef3388439baadbd2f5e360e7b4bd2463 AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.23.3-bookworm@sha256:931de04b8483e6e4729147e5ce921404ef3388439baadbd2f5e360e7b4bd2463
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

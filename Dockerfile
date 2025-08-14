FROM golang:1.24.6-bookworm@sha256:e617461712dbebf8768e10c1a5deab2833d67d2b692894cb8f4f0a3c19a8efb5 AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.24.6-bookworm@sha256:e617461712dbebf8768e10c1a5deab2833d67d2b692894cb8f4f0a3c19a8efb5
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

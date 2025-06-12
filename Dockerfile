FROM golang:1.24.4-bookworm@sha256:ee7ff13d239350cc9b962c1bf371a60f3c32ee00eaaf0d0f0489713a87e51a67 AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.24.4-bookworm@sha256:ee7ff13d239350cc9b962c1bf371a60f3c32ee00eaaf0d0f0489713a87e51a67
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

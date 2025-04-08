FROM golang:1.24.2-bookworm@sha256:f9ce846b2d5f389d529152b0458010afebb165f3cc55fad9c4c82375bd5d2999 AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.24.2-bookworm@sha256:f9ce846b2d5f389d529152b0458010afebb165f3cc55fad9c4c82375bd5d2999
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

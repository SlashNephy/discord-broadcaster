FROM golang:1.22.4-bookworm@sha256:27683a53606aaa5348431e529decc0fdcd89726db0d0fc5258a8103924b8f452 AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.22.4-bookworm@sha256:27683a53606aaa5348431e529decc0fdcd89726db0d0fc5258a8103924b8f452
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

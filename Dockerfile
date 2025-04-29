FROM golang:1.24.2-bookworm@sha256:a642a07319c67a15d52049a16acd16e1da85e735a7b4647f3da51aebe2a277d2 AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.24.2-bookworm@sha256:a642a07319c67a15d52049a16acd16e1da85e735a7b4647f3da51aebe2a277d2
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

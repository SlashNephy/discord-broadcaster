FROM golang:1.25.1-bookworm@sha256:6ad9415c04f1cdb7888141cb247cabb28fa74fcc597034494c65d5bc783246a0 AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.25.1-bookworm@sha256:6ad9415c04f1cdb7888141cb247cabb28fa74fcc597034494c65d5bc783246a0
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

FROM golang:1.25.1-bookworm@sha256:2960a1db140a9a6dd42b15831ec6f8da0c880df98930411194cf11875d433021 AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.25.1-bookworm@sha256:2960a1db140a9a6dd42b15831ec6f8da0c880df98930411194cf11875d433021
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

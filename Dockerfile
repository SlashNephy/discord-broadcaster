FROM golang:1.23.1-bookworm@sha256:ffd95dd933460a35f276d923c1c426dfe3d5e956ad07d3dd0963b148af875ad3 AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.23.1-bookworm@sha256:ffd95dd933460a35f276d923c1c426dfe3d5e956ad07d3dd0963b148af875ad3
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

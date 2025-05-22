FROM golang:1.24.3-bookworm@sha256:212d7b393369e37fb7009a7f6fe30b20fd0d05ee1539d0de116b7c6100061cf4 AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.24.3-bookworm@sha256:212d7b393369e37fb7009a7f6fe30b20fd0d05ee1539d0de116b7c6100061cf4
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

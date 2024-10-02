FROM golang:1.23.2-bookworm@sha256:18d2f940cc20497f85466fdbe6c3d7a52ed2db1d5a1a49a4508ffeee2dff1463 AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.23.2-bookworm@sha256:18d2f940cc20497f85466fdbe6c3d7a52ed2db1d5a1a49a4508ffeee2dff1463
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

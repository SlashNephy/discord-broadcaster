FROM golang:1.23.3-bookworm@sha256:1f001ad8c8d90281cd9d6e0ae4a40363039c148c503bcd483ff38c946b3d4f6d AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.23.3-bookworm@sha256:1f001ad8c8d90281cd9d6e0ae4a40363039c148c503bcd483ff38c946b3d4f6d
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

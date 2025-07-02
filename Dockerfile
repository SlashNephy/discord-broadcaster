FROM golang:1.24.4-bookworm@sha256:7b25b1ea217e0a56060953b3d4859134ecbe757d7434f7ce4756e0c25aad1ef0 AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.24.4-bookworm@sha256:7b25b1ea217e0a56060953b3d4859134ecbe757d7434f7ce4756e0c25aad1ef0
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

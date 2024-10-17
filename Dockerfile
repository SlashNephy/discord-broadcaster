FROM golang:1.23.2-bookworm@sha256:37189aa822b40981cf190ab86481825af5bd9eab8cc4767a975b50785b6300ef AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.23.2-bookworm@sha256:37189aa822b40981cf190ab86481825af5bd9eab8cc4767a975b50785b6300ef
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

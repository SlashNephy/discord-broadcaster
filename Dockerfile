FROM golang:1.22.5-bookworm@sha256:af9b40f2b1851be993763b85288f8434af87b5678af04355b1e33ff530b5765f AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.22.5-bookworm@sha256:af9b40f2b1851be993763b85288f8434af87b5678af04355b1e33ff530b5765f
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

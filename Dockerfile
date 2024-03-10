FROM golang:1.22.1-bookworm AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.22.1-bookworm
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

FROM golang:1.25.1-bookworm@sha256:08c8ac4f6b588d7679ee764023f6ccbf12f629fe7f35d899eca3fcd71813e41e AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.25.1-bookworm@sha256:08c8ac4f6b588d7679ee764023f6ccbf12f629fe7f35d899eca3fcd71813e41e
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

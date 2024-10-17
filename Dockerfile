FROM golang:1.23.2-bookworm@sha256:2eb2527fa642a9ad1e229af63c7510121ea99638c499c87b6e24ad371e17bd9c AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.23.2-bookworm@sha256:2eb2527fa642a9ad1e229af63c7510121ea99638c499c87b6e24ad371e17bd9c
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

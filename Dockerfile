FROM golang:1.23.5-bookworm@sha256:9c79a16e024bcfb856b6d063cf7ed9a6257f554466761f5a99b09787d2b55fbd AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.23.5-bookworm@sha256:9c79a16e024bcfb856b6d063cf7ed9a6257f554466761f5a99b09787d2b55fbd
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

FROM golang:1.24.4-bookworm@sha256:97162678719a516c12d5fb4b08266ab04802358cff63697ab1584be29ee8995c AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.24.4-bookworm@sha256:97162678719a516c12d5fb4b08266ab04802358cff63697ab1584be29ee8995c
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

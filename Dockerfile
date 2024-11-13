FROM golang:1.23.3-bookworm@sha256:11bdd4a00d041f6a5818e9b49a321c81394e44b54a3f13665a9891bf4c749745 AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.23.3-bookworm@sha256:11bdd4a00d041f6a5818e9b49a321c81394e44b54a3f13665a9891bf4c749745
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

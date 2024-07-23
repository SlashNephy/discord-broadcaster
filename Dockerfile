FROM golang:1.22.5-bookworm@sha256:2bb0eaa8ecf0fcc672cce22ba289df6f809e5c19a81becc0ac04a74c13148332 AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.22.5-bookworm@sha256:2bb0eaa8ecf0fcc672cce22ba289df6f809e5c19a81becc0ac04a74c13148332
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

FROM golang:1.24.2-bookworm@sha256:404aa93083340c8919a9a2dea35884a9f1382e1588d3d211f474e10481280d45 AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.24.2-bookworm@sha256:404aa93083340c8919a9a2dea35884a9f1382e1588d3d211f474e10481280d45
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

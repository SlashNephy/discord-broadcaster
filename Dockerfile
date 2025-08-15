FROM golang:1.25.0-bookworm@sha256:74908ad827a5849c557eeca81d46263acf788ead606102d83466f499f83e35b1 AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.25.0-bookworm@sha256:74908ad827a5849c557eeca81d46263acf788ead606102d83466f499f83e35b1
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

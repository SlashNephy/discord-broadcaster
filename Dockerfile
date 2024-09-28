FROM golang:1.23.1-bookworm@sha256:eac972dedeafc7b375b606672c0a453e4697a7eac308a205c5e3907b1eed2ab6 AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.23.1-bookworm@sha256:eac972dedeafc7b375b606672c0a453e4697a7eac308a205c5e3907b1eed2ab6
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

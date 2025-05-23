FROM golang:1.24.3-bookworm@sha256:29d97266c1d341b7424e2f5085440b74654ae0b61ecdba206bc12d6264844e21 AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.24.3-bookworm@sha256:29d97266c1d341b7424e2f5085440b74654ae0b61ecdba206bc12d6264844e21
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

FROM golang:1.24.6-bookworm@sha256:8e0310e96dab53670af8b106f4242b0b0a2509fd3cbaee6504d16b29a441db72 AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.24.6-bookworm@sha256:8e0310e96dab53670af8b106f4242b0b0a2509fd3cbaee6504d16b29a441db72
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

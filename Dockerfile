FROM golang:1.24.4-bookworm@sha256:c83619bb18b0207412fffdaf310f57ee3dd02f586ac7a5b44b9c36a29a9d5122 AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.24.4-bookworm@sha256:c83619bb18b0207412fffdaf310f57ee3dd02f586ac7a5b44b9c36a29a9d5122
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

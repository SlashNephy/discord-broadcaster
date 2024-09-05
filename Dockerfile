FROM golang:1.23.0-bookworm@sha256:32096e84705b30bb39cc9c65ef2896efacc4268203b7876049847763cefc934d AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.23.0-bookworm@sha256:32096e84705b30bb39cc9c65ef2896efacc4268203b7876049847763cefc934d
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

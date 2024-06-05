FROM golang:1.22.4-bookworm@sha256:aec47843e52fee4436bdd3ce931417fa980e9055658b5142140925eea3044bea AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.22.4-bookworm@sha256:aec47843e52fee4436bdd3ce931417fa980e9055658b5142140925eea3044bea
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

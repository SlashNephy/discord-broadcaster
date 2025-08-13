FROM golang:1.24.6-bookworm@sha256:bdc7cfd953b2701fcd95fd591ea3d788f41e4b74f21f1787b9f9843a28e72196 AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.24.6-bookworm@sha256:bdc7cfd953b2701fcd95fd591ea3d788f41e4b74f21f1787b9f9843a28e72196
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

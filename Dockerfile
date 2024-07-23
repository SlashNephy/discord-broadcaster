FROM golang:1.22.5-bookworm@sha256:800e361142daeb47b5e5bce2ede55be8d67159be75748cb31cbb48798ebec39d AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.22.5-bookworm@sha256:800e361142daeb47b5e5bce2ede55be8d67159be75748cb31cbb48798ebec39d
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

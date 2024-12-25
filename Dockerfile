FROM golang:1.23.4-bookworm@sha256:69275b0f10f12fc319e9146abc162ff238a133fc2ee9020ec0c098f108967190 AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.23.4-bookworm@sha256:69275b0f10f12fc319e9146abc162ff238a133fc2ee9020ec0c098f108967190
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

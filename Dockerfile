FROM golang:1.22.6-bookworm@sha256:605adc6fa6a40acd8abf8f3610d9d7037f17f6501c0133dbf16c3abc02f525c4 AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.22.6-bookworm@sha256:605adc6fa6a40acd8abf8f3610d9d7037f17f6501c0133dbf16c3abc02f525c4
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

FROM golang:1.24.5-bookworm@sha256:24ed51360827db30fd73a88a5b911055cffec73bed9d9c0c229bea24af1c98ce AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.24.5-bookworm@sha256:24ed51360827db30fd73a88a5b911055cffec73bed9d9c0c229bea24af1c98ce
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

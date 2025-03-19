FROM golang:1.24.1-bookworm@sha256:677d3daa66e708acd3ffadb429e3c749a1070497208db1e97ae71bec26ab4093 AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.24.1-bookworm@sha256:677d3daa66e708acd3ffadb429e3c749a1070497208db1e97ae71bec26ab4093
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

FROM golang:1.23.4-bookworm@sha256:a82a754724e72f04c7a69c90bef3713c3825edd8a376c233912bec5b46a2ca63 AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.23.4-bookworm@sha256:a82a754724e72f04c7a69c90bef3713c3825edd8a376c233912bec5b46a2ca63
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

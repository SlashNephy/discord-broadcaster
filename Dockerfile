FROM golang:1.23.2-bookworm@sha256:61d20f7495202dde19415ae06b5aff019afa447a7775415b901b3587a51ff04a AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.23.2-bookworm@sha256:61d20f7495202dde19415ae06b5aff019afa447a7775415b901b3587a51ff04a
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

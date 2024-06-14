FROM golang:1.22.4-bookworm@sha256:5f9c6695bf22a466f519506f0157ecd070e81bb3df0f2c975476bf94399237c7 AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.22.4-bookworm@sha256:5f9c6695bf22a466f519506f0157ecd070e81bb3df0f2c975476bf94399237c7
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

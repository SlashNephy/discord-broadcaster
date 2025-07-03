FROM golang:1.24.4-bookworm@sha256:10f549dc8489597aa7ed2b62008199bb96717f52a8e8434ea035d5b44368f8a6 AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.24.4-bookworm@sha256:10f549dc8489597aa7ed2b62008199bb96717f52a8e8434ea035d5b44368f8a6
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

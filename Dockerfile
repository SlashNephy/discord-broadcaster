FROM golang:1.22.6-bookworm@sha256:39b7e6ebaca464d51989858871f792f2e186dce8ce0cbdba7e88e4444b244407 AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.22.6-bookworm@sha256:39b7e6ebaca464d51989858871f792f2e186dce8ce0cbdba7e88e4444b244407
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

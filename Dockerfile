FROM golang:1.24.0-bookworm@sha256:4b9b46046937b4a4860f211449ee0a7fc01111a5a6ece79632abe6db738dd0ca AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.24.0-bookworm@sha256:4b9b46046937b4a4860f211449ee0a7fc01111a5a6ece79632abe6db738dd0ca
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

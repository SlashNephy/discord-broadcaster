FROM golang:1.22.1-bookworm@sha256:6699d2852712f090399ccd4e8dfd079b4d55376f3ab3aff5b2dc8b7b1c11e27e AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.22.1-bookworm@sha256:6699d2852712f090399ccd4e8dfd079b4d55376f3ab3aff5b2dc8b7b1c11e27e
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

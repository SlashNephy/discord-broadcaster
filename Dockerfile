FROM golang:1.23.2-bookworm@sha256:2341ddffd3eddb72e0aebab476222fbc24d4a507c4d490a51892ec861bdb71fc AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.23.2-bookworm@sha256:2341ddffd3eddb72e0aebab476222fbc24d4a507c4d490a51892ec861bdb71fc
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

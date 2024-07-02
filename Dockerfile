FROM golang:1.22.4-bookworm@sha256:0c02666907338370a3272af1b4642a184968911d2317f0bd010dcef89a081d6f AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.22.4-bookworm@sha256:0c02666907338370a3272af1b4642a184968911d2317f0bd010dcef89a081d6f
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

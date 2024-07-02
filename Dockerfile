FROM golang:1.22.4-bookworm@sha256:ee3774bfb3823a8ede2a5bcac5ea9fbd5bf668763be673d48108d1e444e4fc46 AS base
WORKDIR /app

COPY ./go.mod ./go.sum ./
RUN go mod download

FROM base AS build

COPY ./ ./
RUN make build -j

FROM golang:1.22.4-bookworm@sha256:ee3774bfb3823a8ede2a5bcac5ea9fbd5bf668763be673d48108d1e444e4fc46
WORKDIR /app

COPY --from=build /app/server /app/

ENTRYPOINT ["/app/server"]

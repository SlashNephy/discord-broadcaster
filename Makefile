build:
	go build -o ./server ./cmd/server

dev:
	go run github.com/cosmtrek/air

generate:
	go generate ./...

test:
	go test -v ./...

lint:
	go run github.com/golangci/golangci-lint/cmd/golangci-lint run

include ../../Makefile

.PHONY: tidy
tidy:
	go mod tidy

.PHONY: tidy
lint:
	go vet ./...
	go fmt ./...

.PHONY: unit-test
unit-test:
	go test ./...

.PHONY: build
build:
	rm -rf dist
	mkdir -p dist
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build \
		-trimpath \
		-buildvcs=false \
		-ldflags="-s -w" \
		-o cmd/bootstrap \
		./cmd
	cd cmd && zip ../dist/api.zip bootstrap > /dev/null && rm bootstrap

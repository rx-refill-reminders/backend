include ../../Makefile

.PHONY: tidy
tidy:
	go mod tidy

.PHONY: tidy
lint:
	go vet ./...
	go fmt ./...

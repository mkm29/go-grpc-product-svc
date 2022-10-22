PROJECT=go-grpc-product-svc
GH_USER=mkm29

# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

init: ## Initialize the project
	@echo "Initializing the project"
	@go mod init github.com/$(GH_USER)/$(PROJECT)

bootstrap: ## Setup project
	@echo "Setting up the project"
	go get github.com/spf13/viper
	go get google.golang.org/grpc
	go get gorm.io/gorm
	go get gorm.io/driver/postgres
	mkdir -p cmd pkg/config/envs pkg/db pkg/models pkg/pb pkg/services
	touch cmd/main.go pkg/config/envs/dev.env pkg/config/config.go
	touch pkg/pb/product.proto pkg/db/db.go pkg/models/stock_decrease_log.go pkg/models/product.go pkg/services/product.go


build: ## Build the project
	@echo "Building the project"
	@go build -o bin/$(PROJECT) cmd/main.go

proto: ## Generate proto files
	protoc pkg/pb/*.proto --go_out=:. --go-grpc_out=:. 

server: ## Run server
	go run cmd/main.go


# https://stackoverflow.com/questions/71777702/service-compiling-successfully-but-message-structs-not-generating-grpc-go
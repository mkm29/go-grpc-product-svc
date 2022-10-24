# Multistage Go build
FROM golang:1.19.2-alpine3.16 AS builder
RUN apk add --no-cache git
WORKDIR /go/src/github.com/mkm29/product-svc/
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix nocgo -o /app ./cmd/main.go

# Final image
LABEL maintainer="Mitch Murphy <mitch.murphy@gmail.com>" \
  version="0.1.1" \
  description="Product service for Go gRPC demo"
FROM alpine:3.16
ARG DB_HOST="db"
ARG DB_PORT="5432"
ARG DB_DATABASE="product_svc"
ARG DB_USERNAME
ARG DB_PASSWORD
COPY --from=builder /app /product-svc/app
COPY --from=builder /go/src/github.com/mkm29/product-svc/pkg/config/envs/ /product-svc/
ADD https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh /
ENV DB_HOST=$DB_HOST \
  DB_PORT=$DB_PORT \
  DB_USERNAME=$DB_USERNAME \
  DB_PASSWORD=$DB_PASSWORD \
  DB_DATABASE=$DB_DATABASE
EXPOSE 50052
# ENTRYPOINT ["/product-svc/app"]
CMD ["./wait-for-it.sh", "db:5432", "--" , "./order-svc/app"]
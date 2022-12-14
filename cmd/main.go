package main

import (
	"fmt"
	"log"
	"net"

	pb "github.com/mkm29/go-grpc-product-svc/gen/proto/go"
	"github.com/mkm29/go-grpc-product-svc/pkg/config"
	"github.com/mkm29/go-grpc-product-svc/pkg/db"
	"github.com/mkm29/go-grpc-product-svc/pkg/services"
	"google.golang.org/grpc"
)

func main() {
	c, err := config.LoadConfig()

	if err != nil {
		log.Fatalln("Failed at config", err)
	}

	h := db.Init(db.GetConnectionString())

	lis, err := net.Listen("tcp", c.Port)

	if err != nil {
		log.Fatalln("Failed to listing:", err)
	}

	fmt.Println("Product Svc on", c.Port)

	s := services.Server{
		H: h,
	}

	grpcServer := grpc.NewServer()

	pb.RegisterProductServiceServer(grpcServer, &s)

	if err := grpcServer.Serve(lis); err != nil {
		log.Fatalln("Failed to serve:", err)
	}
}

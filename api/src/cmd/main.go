package main

import (
	"context"
	"fmt"
	"net/http"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/rx-refill-reminders/backend/api/src/internal/handler"
	"github.com/rx-refill-reminders/lambda-go/humaserverless"
	"github.com/rx-refill-reminders/lambda-go/middleware"
)

// Run handles an API Gateway request by dispatching to the pre-built API.
func handleRequest(
	ctx context.Context,
	event events.APIGatewayV2HTTPRequest,
) (events.APIGatewayV2HTTPResponse, error) {
	h, err := handler.NewHandlerFromEnv()

	if err != nil {
		return events.APIGatewayV2HTTPResponse{
			StatusCode: http.StatusInternalServerError,
			Body:       fmt.Sprintf("error parsing environment: %v", err.Error()),
		}, nil
	}

	return humaserverless.HttpHandler(ctx, h, event)
}

func main() {
	lambda.Start(middleware.DefaultChain(handleRequest))
}

package client

//go:generate swagger generate client --strict-responders --spec ../server/gen/server.swagger.json --target ./gen --default-scheme=https
//go:generate bash ../../scripts/fix-swagger-validate.sh

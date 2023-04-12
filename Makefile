postgres:
	docker run --name postgres12 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:latest

createdb:
	docker exec -it postgres12 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres12 dropdb simple_bank

migrateup:
	./lib/migrate -path db/migration -database "postgres://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up

migratedown:
	./lib/migrate -path db/migration -database "postgres://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down

sqlc:
	./lib/sqlc generate

test:
	go test -v -cover ./...

proto:
	rm -f schema/gen/*.go
	protoc --proto_path=schema/proto --go_out=schema/gen --go_opt=paths=source_relative \
    --go-grpc_out=schema/gen --go-grpc_opt=paths=source_relative \
    schema/proto/*.proto

.PHONY: postgres createdb dropdb migrateup migratedown sqlc test proto
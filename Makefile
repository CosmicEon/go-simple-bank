DB_URL=postgres://root:secret@localhost:5432/simple_bank?sslmode=disable

postgres:
	docker run --name postgres12 --network bank-network -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:latest

createdb:
	docker exec -it postgres12 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres12 dropdb simple_bank

migrateup:
	./libs/migrate -path db/migration -database "$(DB_URL)" -verbose up

migrateup1:
	./libs/migrate -path db/migration -database "$(DB_URL)" -verbose up 1

migratedown:
	./libs/migrate -path db/migration -database "$(DB_URL)" -verbose down

migratedown1:
	./libs/migrate -path db/migration -database "$(DB_URL)" -verbose down 1

db_docks:
	dbdocs build docs/db.dbml

db_schema:
	dbml2sql --postgres -o docs/schema.sql docs/db.dbml

sqlc:
	./libs/sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/cosmiceon/go-simple-bank/db/sqlc Store

proto:
	rm -f schema/gen/*.go
	protoc --proto_path=schema/proto --go_out=schema/gen --go_opt=paths=source_relative \
    --go-grpc_out=schema/gen --go-grpc_opt=paths=source_relative \
    schema/proto/*.proto

.PHONY: postgres createdb dropdb migrateup migrateup1 migratedown migratedown1 sqlc db_docks db_schema test server mock proto
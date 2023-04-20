# Build stage
FROM golang:1.19.8-alpine3.17 As builder

WORKDIR /app
COPY . .
RUN go build -o main main.go
RUN apk add curl
RUN curl -L https://github.com/golang-migrate/migrate/releases/download/v4.15.2/migrate.linux-386.tar.gz | tar xvz

# Run stage
FROM alpine:3.17

WORKDIR /app
COPY --from=builder /app/main .
COPY --from=builder /app/migrate ./migrate
COPY app.env .
COPY scripts/start.sh .
COPY scripts/wait-for.sh .
COPY db/migration ./migration

EXPOSE 8000
# When CMD is used with ENTRYPOINT, it will be passed as parameter to the execute script in ENTRYPOINT
CMD [ "/app/main" ]
ENTRYPOINT [ "/app/start.sh" ]
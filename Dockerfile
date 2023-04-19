# Build stage
FROM golang:1.19.8-alpine3.17 As builder

WORKDIR /app
COPY . .
RUN go build -o main main.go

# Run stage
FROM alpine:3.17

WORKDIR /app
COPY --from=builder /app/main .
COPY app.env .

EXPOSE 8000
CMD [ "/app/main" ]
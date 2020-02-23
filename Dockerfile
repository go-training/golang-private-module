# Start from the latest golang base image
FROM golang:alpine as Builder

ARG ACCESS_TOKEN
ENV ACCESS_TOKEN=$ACCESS_TOKEN

RUN GOCACHE=OFF

RUN go env -w GOPRIVATE=github.com/appleboy

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy everything from the current directory to the Working Directory inside the container
COPY . .

RUN apk add git

RUN git config --global url."https://appleboy:${ACCESS_TOKEN}@github.com".insteadOf "https://github.com"

# Build the Go app
RUN go build -o main .

# Command to run the executable
CMD ["./main"]

FROM scratch

COPY --from=Builder /app/main /

CMD ["/main"]

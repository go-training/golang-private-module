# Start from the latest golang base image
FROM golang:1.14 as Builder

RUN GOCACHE=OFF

RUN go env -w GOPRIVATE=github.com/appleboy

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy everything from the current directory to the Working Directory inside the container
COPY . .

ARG ACCESS_TOKEN
ENV ACCESS_TOKEN=$ACCESS_TOKEN

RUN git config --global url."https://appleboy:${ACCESS_TOKEN}@github.com".insteadOf "https://github.com"

# Build the Go app
RUN go build -o main .

FROM scratch

COPY --from=Builder /app/main /

CMD ["/main"]

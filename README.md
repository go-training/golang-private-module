# golang-private-module

Go Modules with Private GIT Repository

## Local Machine

```sh
go env -w GOPRIVATE=github.com/appleboy
git config --global url."https://$USERNAME:$ACCESS_TOKEN@github.com".insteadOf "https://github.com"
```

try the private repo:

```sh
go get github.com/appleboy/golang-private
```

## Drone CI

```yaml
steps:
- name: build
  image: golang:1.13
  environment:
    USERNAME:
      from_secret: username
    ACCESS_TOKEN:
      from_secret: access_token
  commands:
  - go env -w GOPRIVATE=github.com/$USERNAME
  - git config --global url."https://$USERNAME:$ACCESS_TOKEN@github.com".insteadOf "https://github.com"
  - go mod tidy
  - go build -o main .
```

## Build Docker Image

See the following:

```dockerfile
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
```

build image using Drone and get docker access token in [security section of setting](https://hub.docker.com/settings/security).

```yaml
- name: build-image
  image: plugins/docker
  environment:
    ACCESS_TOKEN:
      from_secret: access_token
  settings:
    username:
      from_secret: username
    password:
      from_secret: password
    repo: appleboy/golang-module-private
    build_args_from_env:
      - ACCESS_TOKEN
```

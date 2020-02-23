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

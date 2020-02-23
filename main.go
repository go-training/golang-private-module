package main

import (
	"fmt"

	hello "github.com/appleboy/golang-private"
)

func main() {
	fmt.Println("get private module")
	fmt.Println("foo:", hello.Foo())
}

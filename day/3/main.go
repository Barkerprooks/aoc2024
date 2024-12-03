package main

import (
	"fmt"
	"os"
)

func main() {

	data, err := os.ReadFile("day/3/input.txt")

	if err != nil {
		panic(err)
	}

	fmt.Println(string(data))

}
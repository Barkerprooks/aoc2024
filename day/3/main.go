package main

import (
	"fmt"
	"os"
	"regexp"
	"strconv"
)

func main() {

	data, err := os.ReadFile("./day/3/input.txt")

	if err != nil {
		panic(err)
	}

	mulRegex := regexp.MustCompile("mul\\([0-9]+,[0-9]+\\)")
	numRegex := regexp.MustCompile("[0-9]+")

	part1 := 0

	for _, token := range mulRegex.FindAllString(string(data), -1) {
		numbers := numRegex.FindAllString(token, 2)
		
		x, err := strconv.Atoi(numbers[0])
		if err != nil {
			panic(err)
		}

		y, err := strconv.Atoi(numbers[1])
		if err != nil {
			panic(err)
		}

		part1 += x * y
	}

	fmt.Println(part1)
}
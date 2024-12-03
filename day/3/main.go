package main

import (
	"fmt"
	"os"
	"regexp"
	"strconv"
)

type doLocation struct {
	state bool
	index int
}

func main() {

	data, err := os.ReadFile("./day/3/input.txt")

	if err != nil {
		panic(err)
	}

	src := string(data)

	mulRegex := regexp.MustCompile("mul\\([0-9]+,[0-9]+\\)")
	numRegex := regexp.MustCompile("[0-9]+")
	doRegex := regexp.MustCompile("(do\\(\\)|don't\\(\\))")
	
	doQueue := make([]doLocation, 0)
	do := true

	part1 := 0
	part2 := 0

	for _, indicies := range doRegex.FindAllStringIndex(src, -1) {
		token := src[indicies[0]:indicies[1]]
		doQueue = append(doQueue, doLocation{token == "do()", indicies[0]})
	}

	for _, indicies := range mulRegex.FindAllStringIndex(src, -1) {
		token := src[indicies[0]:indicies[1]]
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
	
		// if our current index is greater than the front of the queue's
		// then we have passed a do or a don't. change the state before
		// calculating
		if len(doQueue) > 0 && indicies[0] > doQueue[0].index {
			do = doQueue[0].state // change state
			doQueue = doQueue[1:] // pop the front of the queue
		}
		
		if do {
			part2 += x * y
		}
	}

	fmt.Printf("part 1: %d\n", part1)
	fmt.Printf("part 2: %d\n", part2)
}
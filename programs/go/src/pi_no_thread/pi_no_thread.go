// NON Concurrent computation of pi.
// See https://goo.gl/la6Kli.
//
// This demonstrates Go's ability to handle
// large numbers of concurrent processes.
// It is an unreasonable way to calculate pi.
package main

import (
	"fmt"
	"os"
	"strconv"
	"time"
	// "runtime"
)

//go:noinline
func main() {
	if len(os.Args) != 2 {
		panic("Usage: ./pi_no_threads numTerms:int")
	}

	numTerms, err := strconv.Atoi(os.Args[1])
	if err != nil {
		panic("Usage: ./pi_no_threads numTerms:int")
	}

	start := time.Now()

	fmt.Println(pi(int64(numTerms)))
	fmt.Println(the_count1)
	fmt.Println(the_count2)
	fmt.Println(the_count3)
	

	dt := time.Since(start)

	fmt.Fprintln(os.Stderr, dt.Nanoseconds())
}

// pi launches n goroutines to compute an
// approximation of pi
//go:noinline
func pi(numTerms int64) float64 {
	f := float64(0)
	// sign := int32(1)
	for k := int64(1); k <= numTerms; k++ {
		f += 1.0 / float64(k)
		// sign *= -1
		bar()
	}

	return f
}

var the_count1 = int32(0)
var the_count2 = int32(0)
var the_count3 = int32(0)

//go:noinline
func bar() {
	the_count1 += 1
	the_count2 += 2
    the_count3 += 6
}

//go:noinline
func term(k float64) float64 {
	sign := 2 * -(int64(k) % 2 ) + 1
	bar()
	return float64(4 * sign) / (2*k + 1)
}

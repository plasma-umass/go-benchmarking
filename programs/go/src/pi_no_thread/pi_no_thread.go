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
)

//go:noinline
func main() {
	if len(os.Args) != 2 {
		panic("Usage: ./pi_no_threads numTerms:int")
	}

	numTerms_, err := strconv.Atoi(os.Args[1])
	if err != nil {
		panic("Usage: ./pi_no_threads numTerms:int")
	}
	numTerms := int64(numTerms_)

	start := time.Now()

	fmt.Println(pi(numTerms))

	dt := time.Since(start)

	fmt.Fprintln(os.Stderr, dt.Nanoseconds())
}

// pi launches n goroutines to compute an
// approximation of pi
//go:noinline
func pi(numTerms int64) float64 {
	f := 0.0
	for k := int64(0); k < numTerms; k++ {
		f += term(float64(k))
		// fmt.Println(k)
	}

	return f
}

//go:noinline
func term(k float64) float64 {
	sign := 2 * -(int64(k) % 2 ) + 1
	return float64(4 * sign) / (2*k + 1)
}

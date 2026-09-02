package main

// #include <stdlib.h>
import "C"

import (
	"fmt"
	"unsafe"
)

// The comment below is mandatory and must not have spaces after the slashes
//
//export quick_hello
func quick_hello(cname *C.char) {
	name := C.GoString(cname)
	fmt.Printf("Hello from Go, %s!\n", name)
}

//export full_hello
func full_hello(cname *C.char) *C.char {
	name := C.GoString(cname)
	resultStr := fmt.Sprintf("Hello from Go, %s!", name)

	// Converto to C pointer to be returned to Dart.
	return C.CString(resultStr)
}

//export free_string
func free_string(ptr *C.char) {
	C.free(unsafe.Pointer(ptr))
}

func main() {
	// Main function is required for compiling a C shared library,
	// but it remains empty.
}

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Simple hello world, just prints the name to console
void quick_hello(const char* name) {
    printf("Hello from C, %s!\n", name);
}

// Creates and returns a string with the provided name.
char* full_hello(const char* name) {
    const char* greeting = "Hello ";
    // +2 because of "!" and null terminator
    size_t length = strlen(greeting) + strlen(name) + 2;

    // 🚨 Get memory on the native Heap, need to clean up this manually later from 
    // the caller context (i.e. Dart).
    char* result = (char*)malloc(length);    
    if (result == NULL) return NULL;

    sprintf(result, "%s%s!", greeting, name);

    return result;
}

void free_string(char* ptr) {
    free(ptr);
}

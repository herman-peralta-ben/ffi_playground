import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart'; // Needs the 'ffi' package in pubspec.yaml

// region FullHello Signatures
/// Matches to: `char* full_hello(const char* name)` C function.
typedef _FullHelloC = ffi.Pointer<Utf8> Function(ffi.Pointer<Utf8> name);

/// Matches to: `void free_string(char* ptr)` C function.
typedef _FreeStringC = ffi.Void Function(ffi.Pointer<Utf8> ptr);

// Dart
typedef _FullHelloDart = ffi.Pointer<Utf8> Function(ffi.Pointer<Utf8> name);
typedef _FreeStringDart = void Function(ffi.Pointer<Utf8> ptr);
// endregion FullHello Signatures

String? Function(String) loadFullHelloCFunction(ffi.DynamicLibrary dylib) {
  // Look for the C functions
  final _FullHelloDart fullHello = dylib
      .lookupFunction<_FullHelloC, _FullHelloDart>('full_hello');
  final _FreeStringDart freeString = dylib
      .lookupFunction<_FreeStringC, _FreeStringDart>('free_string');

  return (String name) {
    final namePtr = name.toNativeUtf8();
    final resultPtr = fullHello(namePtr);

    try {
      return resultPtr.toDartString();
    } finally {
      // toNativeUtf8() uses `calloc`, so we free the memory with `calloc.free`.
      calloc.free(namePtr);
      // Free the returned temporal string.
      freeString(resultPtr);
    }
  };
}

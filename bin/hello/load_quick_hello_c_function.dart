import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart'; // Needs the 'ffi' package in pubspec.yaml

// region QuickHello Signatures
/// Matches to: `void quick_hello(char* name)` C function.
typedef _QuickHelloC = ffi.Void Function(ffi.Pointer<Utf8> name);

// Dart
typedef _QuickHelloDart = void Function(ffi.Pointer<Utf8> name);
// endregion QuickHello Signatures

void Function(String) loadQuickHelloCFunction(ffi.DynamicLibrary dylib) {
  // Look for the C function
  final _QuickHelloDart quickHello = dylib
      .lookupFunction<_QuickHelloC, _QuickHelloDart>('quick_hello');

  return (String name) {
    // 'toNativeUtf8()' creates a null-terminated UTF-8 string in native memory
    final namePtr = name.toNativeUtf8();
    try {
      quickHello(namePtr);
    } finally {
      // toNativeUtf8() uses `calloc`, so we free the memory with `calloc.free`.
      calloc.free(namePtr);
    }
  };
}

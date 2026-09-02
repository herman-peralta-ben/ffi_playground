import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart'; // Needs the 'ffi' package in pubspec.yaml
import '../types.dart';

// region Signatures
// C
/// Matches to: `char* full_hello(const char* name)` C function.
typedef FullHelloC = ffi.Pointer<Utf8> Function(ffi.Pointer<Utf8> name);

/// Matches to: `void free_string(char* ptr)` C function.
typedef FreeStringC = ffi.Void Function(ffi.Pointer<Utf8> ptr);

// Dart
typedef HelloDart = ffi.Pointer<Utf8> Function(ffi.Pointer<Utf8> name);
typedef FreeStringDart = void Function(ffi.Pointer<Utf8> ptr);

// endregion Signatures

/// Loads the 'full_hello' function passing a name string, and returning the result string.
/// Returns a lambda to execute the function whenever you need it.
/// ### Example:
/// ```dart
/// final bridge = loadFullHelloC();
/// print(bridge.fn("World"));
/// bridge.dispose();
/// ```
///
/// **Note:** This requires a compiled library (e.g. `libhello.dylib` on Mac) to be present in the `./lib/` directory. Please check the README.md for more details.
BridgeStringString loadFullHelloC([
  String libName = "libhello.dylib",
]) {
  final dylib = ffi.DynamicLibrary.open('./lib/$libName');

  // Look for the C functions
  final HelloDart fullHello = dylib.lookupFunction<FullHelloC, HelloDart>(
    'full_hello',
  );
  final FreeStringDart freeString = dylib
      .lookupFunction<FreeStringC, FreeStringDart>('free_string');

  // Return a "bridge" record, so we can execute and dispose the C method whenever we want.
  return (
    fn:
        // Lambda that calls the function and handles the memory
        (String name) {
          final namePtr = name.toNativeUtf8();
          final resultPtr = fullHello(namePtr);

          try {
            return resultPtr.toDartString();
          } finally {
            malloc.free(namePtr);
            freeString(resultPtr);
          }
        },
    dispose: dylib.close,
  );
}

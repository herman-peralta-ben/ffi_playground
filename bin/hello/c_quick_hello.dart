import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import '../types.dart';

// region Signatures
/// Matches to: `void quick_hello(char* name)` C function.
typedef QuickHelloC = ffi.Void Function(ffi.Pointer<Utf8> name);
//    Dart
typedef QuickHelloDart = void Function(ffi.Pointer<Utf8> name);
// endregion Signatures

/// Calls the `quick_hello` C function synchronously on the Main Thread.
/// This ensures zero latency between Dart and the Native C logic,
/// making it ideal for high-performance CLI tools or engine embeddings.
/// ### Example:
/// ```dart
/// final bridge = loadQuickHelloC();
/// bridge.fn("World");
/// bridge.dispose();
/// ```
///
/// **Note:** This requires a compiled library (e.g. `libhello.dylib` on Mac) to be present in the `./lib/` directory. Please check the README.md for more details.
BridgeStringVoid loadQuickHelloC([
  String libName = "libhello.dylib",
]) {
  final dylib = ffi.DynamicLibrary.open('./lib/$libName');

  // Look for the C function
  final QuickHelloDart quickHello = dylib
      .lookupFunction<QuickHelloC, QuickHelloDart>('quick_hello');

  // Return a "bridge" record, so we can execute and dispose the C method whenever we want.
  return (
    fn:
        // Lambda that calls the function and handles the memory
        (String name) {
          // 'toNativeUtf8()' creates a null-terminated UTF-8 string in native memory
          final namePtr = name.toNativeUtf8();
          try {
            quickHello(namePtr);
          } finally {
            // Note that we need to manually free the memory.
            calloc.free(namePtr);
          }
        },
    dispose: dylib.close,
  );
}

import 'dart:ffi' as ffi;

import '../common/native_bridge.dart';
import 'load_full_hello_c_function.dart';
import 'load_quick_hello_c_function.dart';

/// This class keeps a bridge with the Hello implementation in C, Rust and Go.
/// See README.md for compilation details.
class HelloNativeBridge extends NativeBridge {
  final void Function(String) quickHello;
  final String? Function(String) fullHello;

  HelloNativeBridge({
    required this.quickHello,
    required this.fullHello,
    required super.dispose,
  });

  static String resolveLibPath(String libName) => "./lib/hello/$libName";

  factory HelloNativeBridge._initialize(String libName) {
    final path = resolveLibPath(libName);
    final dylib = ffi.DynamicLibrary.open(path);

    return HelloNativeBridge(
      quickHello: loadQuickHelloCFunction(dylib),
      fullHello: loadFullHelloCFunction(dylib),
      dispose: dylib.close,
    );
  }

  factory HelloNativeBridge.c() =>
      HelloNativeBridge._initialize("libhello_c.dylib");
  factory HelloNativeBridge.rust() =>
      HelloNativeBridge._initialize("libhello_rust.dylib");

  /// Call [exit(0)] from dart:io after [dispose]
  /// 🚨 When Go binaries are compiled using '-buildmode=c-shared',
  /// Go's runtime spawns background threads that keep the process alive.
  /// We force exit here to terminate them and close the app.
  factory HelloNativeBridge.go() =>
      HelloNativeBridge._initialize("libhello_go.dylib");
}

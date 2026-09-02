import 'package:test/test.dart';
import '../../bin/hello/hello_native_bridge.dart';

void main() {
  group("loading dynamic library normally", () {
    test("C Bridge loads normally", () {
      expect(() => HelloNativeBridge.c(), returnsNormally);
    });

    test("Rust Bridge loads normally", () {
      expect(() => HelloNativeBridge.rust(), returnsNormally);
    });

    test("Go Bridge loads normally", () {
      expect(() => HelloNativeBridge.go(), returnsNormally);
    });
  });

  group("loading right library", () {
    test("C Bridge loads right C library", () {
      final path = HelloNativeBridge.resolveLibPath("libhello_c.dylib");
      expect(path, equals("./lib/hello/libhello_c.dylib"));
    });

    test("Rust Bridge loads right Rust library", () {
      final path = HelloNativeBridge.resolveLibPath("libhello_rust.dylib");
      expect(path, equals("./lib/hello/libhello_rust.dylib"));
    });

    test("C Bridge loads right Go library", () {
      final path = HelloNativeBridge.resolveLibPath("libhello_go.dylib");
      expect(path, equals("./lib/hello/libhello_go.dylib"));
    });
  });

  group("bridge returns expected values", () {
    test("C Bridge returns expected values", () {
      final cBridge = HelloNativeBridge.c();
      expect(cBridge.fullHello("test"), "Hello from C, test!");
    });

    test("Rust Bridge returns expected values", () {
      final cBridge = HelloNativeBridge.rust();
      expect(cBridge.fullHello("test"), "Hello from Rust, test!");
    });

    test("Go Bridge returns expected values", () {
      final cBridge = HelloNativeBridge.go();
      expect(cBridge.fullHello("test"), "Hello from Go, test!");
    });
  });
}

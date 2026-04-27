import 'c_full_hello.dart';
import 'c_quick_hello.dart';

({void Function(String name) fn, void Function() dispose}) loadQuickHelloRust([
  String libName = "libhello_rust.dylib",
]) {
  return loadQuickHelloC(libName);
}

({String Function(String name) fn, void Function() dispose}) loadFullHelloRust([
  String libName = "libhello_rust.dylib",
]) {
  return loadFullHelloC(libName);
}

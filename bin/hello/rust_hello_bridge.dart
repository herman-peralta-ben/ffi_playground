import 'c_full_hello.dart';
import 'c_quick_hello.dart';
import '../types.dart';

const _rustHelloLib = "libhello_rust.dylib";

BridgeStringVoid loadQuickHelloRust() {
  return loadQuickHelloC(_rustHelloLib);
}

BridgeStringString loadFullHelloRust() {
  return loadFullHelloC(_rustHelloLib);
}

import 'c_full_hello.dart';
import 'c_quick_hello.dart';
import '../types.dart';

const _goHelloLib = "libhello_go.dylib";

BridgeStringVoid loadQuickHelloGoBridge() {
  return loadQuickHelloC(_goHelloLib);
}

BridgeStringString loadFullHelloGoBridge() {
  return loadFullHelloC(_goHelloLib);
}

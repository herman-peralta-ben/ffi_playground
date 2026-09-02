import 'dart:io';
import 'dart:math';

import 'hello/hello_native_bridge.dart';

void main(List<String> arguments) {
  final helloCBridge = HelloNativeBridge.c();
  final helloRustBridge = HelloNativeBridge.rust();
  final helloGoBridge = HelloNativeBridge.go();
  print("======= C ======");
  _showcaseHelloBridge(helloCBridge);
  print("======= Rust ======");
  _showcaseHelloBridge(helloRustBridge);
  print("======= Go ======");
  _showcaseHelloBridge(helloGoBridge);
  exit(0);
}

void _showcaseHelloBridge(HelloNativeBridge bridge) {
  final rand = Random.secure();
  final nativeArg = rand.nextInt(100).toString();

  bridge.quickHello("World");
  print(bridge.fullHello(nativeArg));
  bridge.dispose();
}

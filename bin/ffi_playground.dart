import 'dart:io';

import 'package:args/args.dart';
import 'hello/c_quick_hello.dart';
import 'hello/c_full_hello.dart';
import 'hello/rust_hello_bridge.dart';
import 'hello/go_hello_bridge.dart';

const String version = '0.0.1';

ArgParser buildParser() {
  return ArgParser()
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print this usage information.',
    )
    ..addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      help: 'Show additional command output.',
    )
    ..addFlag('version', negatable: false, help: 'Print the tool version.');
}

void printUsage(ArgParser argParser) {
  print('Usage: dart ffi_playground.dart <flags> [arguments]');
  print(argParser.usage);
}

void main(List<String> arguments) {
  final ArgParser argParser = buildParser();
  try {
    final ArgResults results = argParser.parse(arguments);
    bool verbose = false;

    // Process the parsed arguments.
    if (results.flag('help')) {
      printUsage(argParser);
      return;
    }
    if (results.flag('version')) {
      print('ffi_playground version: $version');
      return;
    }
    if (results.flag('verbose')) {
      verbose = true;
    }

    // Act on the arguments provided.
    print('Positional arguments: ${results.rest}');
    if (verbose) {
      print('[VERBOSE] All arguments: ${results.arguments}');
    }

    print("======= C ======");
    _helloC();
    print("======= Rust ======");
    _helloRust();
    print("======= Go ======");
    _helloGo();
    
    // 🚨 When Go binaries are compiled using '-buildmode=c-shared', 
    // Go's runtime spawns background threads that keep the process alive.
    // We force exit here to terminate them and close the app.
    exit(0);
    //_helloGo();
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    print('');
    printUsage(argParser);
  }
}

void _helloC() {
  final quickHelloBridge = loadQuickHelloC();
  quickHelloBridge.fn("World");

  final fullHelloBridge = loadFullHelloC();
  final result = fullHelloBridge.fn("42");
  print(result);

  // Dispose
  quickHelloBridge.dispose();
  fullHelloBridge.dispose();
}

void _helloRust() {
  final quickHelloBridge = loadQuickHelloRust();
  quickHelloBridge.fn("World");

  final fullHelloBridge = loadFullHelloRust();
  final result = fullHelloBridge.fn("42");
  print(result);

  // Dispose
  quickHelloBridge.dispose();
  fullHelloBridge.dispose();
}

void _helloGo() {
  final quickHelloGoBridge = loadQuickHelloGoBridge();
  quickHelloGoBridge.fn("World");

  final fullHelloGoBridge = loadFullHelloGoBridge();
  final result = fullHelloGoBridge.fn("42");
  print(result);

  // Dispose
  quickHelloGoBridge.dispose();
  fullHelloGoBridge.dispose();
}

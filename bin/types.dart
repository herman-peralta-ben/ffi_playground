/// Record that represents the bridge to a native function that requires
/// String and returns nothing.
/// Call [dispose] once you got the string in dart.
typedef BridgeStringVoid = ({
  void Function(String name) fn, 
  void Function() dispose,
});

/// Record that represents the bridge to a native function that requires
/// String and returns String.
/// Call [dispose] once you got the string in dart.
typedef BridgeStringString = ({
  String? Function(String name) fn, 
  void Function() dispose,
});

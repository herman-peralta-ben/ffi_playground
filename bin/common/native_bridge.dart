typedef Dispose = void Function();

abstract class NativeBridge {
  final Dispose dispose;

  NativeBridge({
    required this.dispose,
  });
}

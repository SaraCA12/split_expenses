class IdGenerator {
  static int _counter = 0;

  /// Genera IDs únicos simples para el mock backend.
  /// Cuando conectes un backend real, esto lo reemplaza el ID que devuelva la API.
  static String generate() {
    _counter++;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${timestamp}_$_counter';
  }
}
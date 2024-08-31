import 'package:flutter_test/flutter_test.dart';

import 'package:atomlib/atomlib.dart';

void main() {
  test('simple manipulation', () {
    final atom = Atom<int>(0);
    expect(atom.value, 0);
    atom.value += 1;
    expect(atom.value, 1);
  });
}

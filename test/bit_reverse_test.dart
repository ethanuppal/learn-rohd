import 'package:test/test.dart';

import '../bin/learn_rohd.dart';

void expectBitReverse(String input, int bits, String expected) {
  int bin(String binary) => int.parse(binary, radix: 2);

  test('', () {
    expect(bitReverse(bin(input), bits), equals(bin(expected)));
  });
}

void main() {
  expectBitReverse('0001', 4, '1000');
  expectBitReverse('0011', 4, '1100');
  expectBitReverse('1010', 4, '0101');
  expectBitReverse('11110000', 8, '00001111');
  expectBitReverse('00000001', 8, '10000000');
  expectBitReverse('00000000', 8, '00000000');
}

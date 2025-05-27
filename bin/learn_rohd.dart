import 'package:rohd/rohd.dart';
import 'package:rohd_hcl/rohd_hcl.dart';

class Counter extends Module {
  Logic get val => output('val');

  final int width;

  Counter(
    Logic en,
    Logic reset,
    Logic clk, {
    this.width = 8,
    super.name = 'counter',
  }) {
    en = addInput('en', en);
    reset = addInput('reset', reset);
    clk = addInput('clk', clk);
    addOutput('val', width: width);

    val <= flop(clk, reset: reset, en: en, val + 1);
  }
}

int bitReverse(int value, int bits) {
  int reversed = 0;
  for (int i = 0; i < bits; i++) {
    reversed <<= 1;
    reversed |= (value & 1);
    value >>= 1;
  }
  return reversed;
}

class BitReverse extends Module {
  BitReverse(
    Logic en,
    Logic clk,
    Logic reset,
    LogicArray input, {
    super.name = 'bit_reversal',
  }) : assert(input.dimensions.length == 1) {
    en = addInput('en', en);
    clk = addInput('clk', clk);
    reset = addInput('reset', reset);
    input = addInputArray(
      'input_array',
      input,
      dimensions: input.dimensions, // it seems like these are needed
      elementWidth: input.elementWidth,
      numUnpackedDimensions: input.numUnpackedDimensions,
    );

    LogicArray out = addOutputArray(
      'out',
      dimensions: input.dimensions,
      elementWidth: input.elementWidth,
      numUnpackedDimensions: input.numUnpackedDimensions,
    );

    final int length = input.dimensions[0];
    final int bits = log2Ceil(length);

    for (var i = 0; i < length; i++) {
      out.elements[bitReverse(i, bits)] <= input.elements[i];
    }
  }
}

class FFT extends Module {
  FFT() {}
}

Future<void> main() async {
  final counter = BitReverse(
    Logic(name: 'en'),
    Logic(name: 'reset'),
    Logic(name: 'clk'),
    LogicArray([8], 8, name: 'array', numUnpackedDimensions: 1),
  );

  await counter.build();
  final generatedSystemVerilog = counter.generateSynth();
  print(generatedSystemVerilog);
}

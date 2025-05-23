import 'package:rohd/rohd.dart';

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

Future<void> main() async {
  final counter = Counter(
    Logic(name: "en"),
    Logic(name: "reset"),
    Logic(name: "clk"),
  );

  await counter.build();
  final generatedSystemVerilog = counter.generateSynth();
  print(generatedSystemVerilog);
}

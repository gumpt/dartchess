@Tags(['perft'])
import 'package:test/test.dart';
import 'dart:io';
import 'package:dartchess/dartchess.dart';

class Perft {
  String id;
  String fen;
  List<TestCase> cases;

  Perft(this.id, this.fen, this.cases);
}

class TestCase {
  int depth;
  int nodes;

  TestCase(this.depth, this.nodes);
}

class Parser {
  List<Perft> parse(String input) {
    final lines = input.split('\n');
    final perftBlocks = _splitBlocks(lines).map(_parsePerft);
    return perftBlocks.toList();
  }

  static Iterable<List<String>> _splitBlocks(List<String> lines) sync* {
    final block = <String>[];
    for (final line in lines) {
      if (line.startsWith('#')) {
        continue; // Ignore comments and blank lines
      }

      if (line.trim().isEmpty && block.isNotEmpty) {
        yield block.toList();
        block.clear();
      }

      if (line.isNotEmpty) {
        block.add(line);
      }
    }
    if (block.isNotEmpty) {
      yield block.toList();
    }
  }

  static Perft _parsePerft(List<String> block) {
    final id = block[0].substring(3);
    final epd = block[1].substring(3).trim();
    final cases = block.skip(2).map(_parseTestCase);
    return Perft(id, epd, cases.toList());
  }

  static TestCase _parseTestCase(String line) {
    final parts = line.trim().split(RegExp('\\s+'));
    final depth = int.parse(parts[1]);
    final nodes = int.parse(parts[2]);
    return TestCase(depth, nodes);
  }
}

void main() async {
  var tests =
      Parser().parse(await File('test/resources/3check.perft').readAsString());

  group('Three Check', () {
    for (final perftTest in tests) {
      final position = ThreeCheck.fromSetup(Setup.parseFen(perftTest.fen));
      for (final testCase in perftTest.cases) {
        test('${perftTest.id} ${perftTest.fen} ${testCase.depth}', () {
          expect(perft(position, testCase.depth), testCase.nodes,
              reason:
                  'id: ${perftTest.id}\nfen: ${perftTest.fen} \ndepth: ${testCase.depth} \nnodes: ${testCase.nodes}');
        });
      }
    }
  });
  tests = Parser()
      .parse(await File('test/resources/antichess.perft').readAsString());

  group('Antichess', () {
    for (final perftTest in tests) {
      final position = Antichess.fromSetup(Setup.parseFen(perftTest.fen));
      for (final testCase in perftTest.cases) {
        test('${perftTest.id} ${perftTest.fen} ${testCase.depth}', () {
          expect(perft(position, testCase.depth), testCase.nodes,
              reason:
                  'id: ${perftTest.id}\nfen: ${perftTest.fen} \ndepth: ${testCase.depth} \nnodes: ${testCase.nodes}');
        });
      }
    }
  });
  tests =
      Parser().parse(await File('test/resources/atomic.perft').readAsString());

  group('Atomic', () {
    for (final perftTest in tests) {
      final position = Atomic.fromSetup(Setup.parseFen(perftTest.fen));
      for (final testCase in perftTest.cases) {
        test('Atomic ${perftTest.id} ${perftTest.fen} ${testCase.depth}', () {
          expect(perft(position, testCase.depth), testCase.nodes,
              reason:
                  'id: ${perftTest.id}\nfen: ${perftTest.fen} \ndepth: ${testCase.depth} \nnodes: ${testCase.nodes}');
        });
      }
    }
  });
  tests = Parser()
      .parse(await File('test/resources/crazyhouse.perft').readAsString());

  group('Crazyhouse', () {
    for (final perftTest in tests) {
      final position = Crazyhouse.fromSetup(Setup.parseFen(perftTest.fen));
      for (final testCase in perftTest.cases) {
        test('${perftTest.id} ${perftTest.fen} ${testCase.depth}', () {
          expect(perft(position, testCase.depth), testCase.nodes,
              reason:
                  'id: ${perftTest.id}\nfen: ${perftTest.fen} \ndepth: ${testCase.depth} \nnodes: ${testCase.nodes}');
        });
      }
    }
  });
  tests =
      Parser().parse(await File('test/resources/horde.perft').readAsString());

  group('Horde', () {
    for (final perftTest in tests) {
      final position = Horde.fromSetup(Setup.parseFen(perftTest.fen));
      for (final testCase in perftTest.cases) {
        test('${perftTest.id} ${perftTest.fen} ${testCase.depth}', () {
          expect(perft(position, testCase.depth), testCase.nodes,
              reason:
                  'id: ${perftTest.id}\nfen: ${perftTest.fen} \ndepth: ${testCase.depth} \nnodes: ${testCase.nodes}');
        });
      }
    }
  });
  tests = Parser()
      .parse(await File('test/resources/racingkings.perft').readAsString());

  group('Racing Kings', () {
    for (final perftTest in tests) {
      final position = RacingKings.fromSetup(Setup.parseFen(perftTest.fen));
      for (final testCase in perftTest.cases) {
        test('${perftTest.id} ${perftTest.fen} ${testCase.depth}', () {
          expect(perft(position, testCase.depth), testCase.nodes,
              reason:
                  'id: ${perftTest.id}\nfen: ${perftTest.fen} \ndepth: ${testCase.depth} \nnodes: ${testCase.nodes}');
        });
      }
    }
  });
  tests =
      Parser().parse(await File('test/resources/tricky.perft').readAsString());

  group('Chess Tricky', () {
    for (final perftTest in tests) {
      for (final testCase in perftTest.cases) {
        test('${perftTest.id} ${perftTest.fen} ${testCase.depth}', () {
          final position = Chess.fromSetup(Setup.parseFen(perftTest.fen),
              ignoreImpossibleCheck:
                  true); // true: otherwise there is an Impossible Check Error
          expect(perft(position, testCase.depth), testCase.nodes,
              reason:
                  'id: ${perftTest.id}\nfen: ${perftTest.fen} \ndepth: ${testCase.depth} \nnodes: ${testCase.nodes}');
        });
      }
    }
  });
  tests =
      Parser().parse(await File('test/resources/random.perft').readAsString());

  group('Random', () {
    for (final perftTest in tests) {
      final position = Chess.fromSetup(Setup.parseFen(perftTest.fen));
      for (final testCase in perftTest.cases) {
        test('${perftTest.id} ${perftTest.fen}  ${testCase.depth}', () {
          expect(perft(position, testCase.depth), testCase.nodes,
              reason:
                  'id: ${perftTest.id}\nfen: ${perftTest.fen} \ndepth: ${testCase.depth} \nnodes: ${testCase.nodes}');
        });
      }
    }
  });

  tests = Parser()
      .parse(await File('test/resources/chess960.perft').readAsString());
  group('Chess 960', () {
    for (final perftTest in tests) {
      final position = Chess.fromSetup(Setup.parseFen(perftTest.fen));
      for (final testCase in perftTest.cases) {
        test('Chess 960 ${perftTest.id} ${perftTest.fen} ${testCase.depth}',
            () {
          expect(perft(position, testCase.depth), testCase.nodes,
              reason:
                  'id: ${perftTest.id}\nfen: ${perftTest.fen} \ndepth: ${testCase.depth} \nnodes: ${testCase.nodes}');
        });
      }
    }
  });
}

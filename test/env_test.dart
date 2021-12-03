import 'dart:io';

import 'package:dotenv/dotenv.dart' show load, env;
import 'package:flutter_test/flutter_test.dart';

extension BoolParsing on String {
  bool parseBool() {
    if (toLowerCase() == 'true') {
      return true;
    } else if (toLowerCase() == 'false') {
      return false;
    }

    throw Exception('Could not parse bool from $this');
  }
}

void main() {
  setUpAll(() async {
    load('.env.example');
  });

  group('Load test ENV', () {
    setUp(() {
      // ignore: avoid_print
      print(Directory.current.toString());
    });
    test('able to load .env', () {
      final String sandbox = env['SANDBOX']!;
      final bool isSandBox = sandbox.parseBool();
      expect(true, isSandBox);
    });
  });
}

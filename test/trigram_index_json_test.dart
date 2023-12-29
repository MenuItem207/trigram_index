import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:trigram_index/trigram_index.dart';

void main() {
  test(
    'Test jsonification',
    () {
      List<String> strings = [
        'a',
        'fjlsd',
        'dsfjlkfjsdl',
        'fdsjlk',
        'ehe',
        'fjdke',
      ];

      TrigramIndex index = TrigramIndex.buildIndex(strings);

      Map json = index.toJson();
      String jsonString = jsonEncode(json);

      Map backJson = jsonDecode(jsonString);
      TrigramIndex index2 = TrigramIndex.fromJson(backJson);
      expect(index2.trigramOriginalStrings.length,
          index.trigramOriginalStrings.length);
      expect(index2.index.length, index.index.length);
    },
  );
}

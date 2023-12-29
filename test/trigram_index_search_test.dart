import 'package:flutter_test/flutter_test.dart';
import 'package:trigram_index/trigram_index.dart';

void main() {
  test('Test search', () {
    List<String> strings = [
      'Admiralty',
      'Woodlands',
      'SembwWaang 1045',
      'Yew Tee 2920',
      'Orange 3920',
      'Miracle'
    ];

    TrigramIndex index = TrigramIndex.buildIndex(strings);

    print(index.search('920'));
  });
}

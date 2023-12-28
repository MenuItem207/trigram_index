library trigram_index;

class TrigramIndex {
  TrigramIndex();

  /// the actual index, maps each trigram (three letter sequence) to a list of unique identifiers which are either strings or ints
  Map<String, List> index = {};

  /// the original strings used
  List<String> trigramOriginalStrings = [];

  /// runs a search
  List<String> search(String search) {
    List<String> searchTrigrams = generateTrigramListFrom(search);
    List ids = [];
    for (String trigram in searchTrigrams) {
      ids.addAll(index[trigram] ?? []);
    }

    ids = ids.toSet().toList();

    return ids.map((index) => trigramOriginalStrings[index]).toList();
  }

  /// adds a relevant string's trigrams to the [index]
  void addStringToIndex(String string) {
    List<String> trigrams = generateTrigramListFrom(string);

    int stringIndex = trigramOriginalStrings.length;
    trigramOriginalStrings.add(string);

    for (String trigram in trigrams) {
      if (index.containsKey(trigram)) {
        index[trigram]!.add(stringIndex);
      } else {
        index[trigram] = [stringIndex];
      }
    }
  }

  /// builds [index] from a list of strings
  factory TrigramIndex.buildIndex(List<String> strings) {
    TrigramIndex trigramIndex = TrigramIndex();
    for (String string in strings) {
      trigramIndex.addStringToIndex(string);
    }

    return trigramIndex;
  }

  /// generates a lowercase trigram list from [string]
  /// i.e 'Hi my name is' = ['hi ', i m'...]
  static List<String> generateTrigramListFrom(String string) {
    string = string.toLowerCase(); // * IMPORTANT

    if (string.length <= 3) return [string];

    List<String> trigrams = [];
    for (int i = 0; i < string.length - 2; i++) {
      trigrams.add(string.substring(i, i + 3));
    }
    return trigrams;
  }
}

library trigram_index;

class TrigramIndex {
  TrigramIndex();

  /// the actual index, maps each trigram (three letter sequence) to a list of indexes
  Map<String, List> index = {};

  /// the original strings used
  List<String> trigramOriginalStrings = [];

  /// runs a search, returns a list of original strings ordered by their most relevance (desc)
  List<String> search(String search) {
    List<String> searchTrigrams = generateTrigramListFrom(search);
    List ids = [];
    for (String trigram in searchTrigrams) {
      ids.addAll(index[trigram] ?? []);
    }

    // maps an id to its count
    Map<int, int> idCount = {};
    for (int id in ids) {
      if (idCount.containsKey(id)) {
        idCount[id] = idCount[id]! + 1;
      } else {
        idCount[id] = 1;
      }
    }

    List<MapEntry> sortedIDEntries = idCount.entries
        // Sort entries in descending order based on their count
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Extract only the IDs from the sorted entries
    return sortedIDEntries
        .map((entry) => trigramOriginalStrings[entry.key])
        .toList();
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

  /// to json
  Map toJson() {
    return {
      'i': index,
      't': trigramOriginalStrings,
    };
  }

  /// builds [index] from a list of strings
  factory TrigramIndex.buildIndex(List<String> strings) {
    TrigramIndex trigramIndex = TrigramIndex();
    for (String string in strings) {
      trigramIndex.addStringToIndex(string);
    }

    return trigramIndex;
  }

  /// from json
  factory TrigramIndex.fromJson(Map json) {
    TrigramIndex trigramIndex = TrigramIndex();

    trigramIndex.index = Map<String, List>.from(json['i']);
    trigramIndex.trigramOriginalStrings = List<String>.from(json['t']);

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

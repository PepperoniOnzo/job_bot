class ParsedData {
  final String title, link;

  ParsedData(this.title, this.link);

  @override
  String toString() {
    return '$title\n$link';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParsedData &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          link == other.link;

  /// Creates a [ParsedData] object from a [Map]
  factory ParsedData.fromJson(Map<String, dynamic> json) => ParsedData(
        json['title'],
        json['link'],
      );

  /// Creates a [Map] from a [ParsedData] object
  Map<String, dynamic> toJson() => {
        'title': title,
        'link': link,
      };

  @override
  int get hashCode => title.hashCode ^ link.hashCode;
}

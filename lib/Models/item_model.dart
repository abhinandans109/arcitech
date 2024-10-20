class Item {
  final String title;
  final String imageUrl;
  final String imageUrlMed;
  final String description;

  Item({
    required this.title,
    required this.imageUrl,
    required this.imageUrlMed,
    required this.description,
  });

  // Factory method to create an Item from a JSON response
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      title: json['photographer'],
      imageUrl: json['src']['original'],
      imageUrlMed: json['src']['small'],
      description: json['photographer_url'],
    );
  }
}

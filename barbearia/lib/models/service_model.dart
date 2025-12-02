class ServiceModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final int durationMinutes;
  final String? imageUrl;

  ServiceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.durationMinutes,
    this.imageUrl,
  });

  factory ServiceModel.fromMap(Map<String, dynamic> map, String id) {
    return ServiceModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      durationMinutes: (map['durationMinutes'] ?? 30) as int,
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'durationMinutes': durationMinutes,
      'imageUrl': imageUrl,
    };
  }
}

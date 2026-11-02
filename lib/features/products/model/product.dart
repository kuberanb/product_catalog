class Product {
  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.rating,
    required this.image,
    this.description = '',
    this.brand = '',
    this.category = '',
    this.stock = 0,
    this.barcode = '',
    this.sku = '',
    this.images = const [],
  });

  final int id;
  final String title;
  final double price;
  final double rating;
  final String image;
  final String description;
  final String brand;
  final String category;
  final int stock;
  final String barcode;
  final String sku;
  final List<String> images;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: (json['id'] as num).toInt(),
    title: json['title'] as String,
    price: (json['price'] as num).toDouble(),
    rating: (json['rating'] as num).toDouble(),
    image: json['thumbnail'] as String? ?? '',
    description: json['description'] as String? ?? '',
    brand: json['brand'] as String? ?? '',
    category: json['category'] as String? ?? '',
    stock: (json['stock'] as num?)?.toInt() ?? 0,
    barcode: (json['meta'] as Map?)?['barcode'] as String? ?? '',
    sku: json['sku'] as String? ?? '',
    images: List<String>.unmodifiable(
      (json['images'] as List? ?? const []).whereType<String>(),
    ),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'price': price,
    'rating': rating,
    'thumbnail': image,
    'description': description,
    'brand': brand,
    'category': category,
    'stock': stock,
    'meta': {'barcode': barcode},
    'sku': sku,
    'images': images,
  };
}

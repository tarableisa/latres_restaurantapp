import 'dart:convert';

class RestaurantDetail {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final String address;
  final double rating;
  final List<String> categories;
  final List<String> foods;
  final List<String> drinks;
  final List<CustomerReview> customerReviews;

  RestaurantDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.address,
    required this.rating,
    required this.categories,
    required this.foods,
    required this.drinks,
    required this.customerReviews,
  });

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) {
    return RestaurantDetail(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      pictureId: json['pictureId'],
      city: json['city'],
      address: json['address'],
      rating: (json['rating'] as num).toDouble(),
      categories:
          List<String>.from(json['categories'].map((c) => c['name'])),
      foods:
          List<String>.from(json['menus']['foods'].map((m) => m['name'])),
      drinks:
          List<String>.from(json['menus']['drinks'].map((m) => m['name'])),
      customerReviews: List<CustomerReview>.from(
        json['customerReviews']
            .map((r) => CustomerReview.fromJson(r)),
      ),
    );
  }

  factory RestaurantDetail.fromMap(Map<String, dynamic> m) {
    return RestaurantDetail(
      id: m['id'],
      name: m['name'],
      description: m['description'],
      pictureId: m['pictureId'],
      city: m['city'],
      address: m['address'],
      rating: (m['rating'] as num).toDouble(),
      categories: List<String>.from(jsonDecode(m['categories'])),
      foods: List<String>.from(jsonDecode(m['foods'])),
      drinks: List<String>.from(jsonDecode(m['drinks'])),
      customerReviews: (jsonDecode(m['customerReviews']) as List)
          .map((e) => CustomerReview.fromMap(e))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'pictureId': pictureId,
      'city': city,
      'address': address,
      'rating': rating,
      'categories': jsonEncode(categories),
      'foods': jsonEncode(foods),
      'drinks': jsonEncode(drinks),
      'customerReviews':
          jsonEncode(customerReviews.map((c) => c.toMap()).toList()),
    };
  }
}

class CustomerReview {
  final String name;
  final String review;
  final String date;

  CustomerReview({
    required this.name,
    required this.review,
    required this.date,
  });

  factory CustomerReview.fromJson(Map<String, dynamic> json) => CustomerReview(
        name: json['name'],
        review: json['review'],
        date: json['date'],
      );

  factory CustomerReview.fromMap(Map<String, dynamic> m) => CustomerReview(
        name: m['name'],
        review: m['review'],
        date: m['date'],
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'review': review,
        'date': date,
      };
}

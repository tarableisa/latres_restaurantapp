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
          List<String>.from(json['categories'].map((cat) => cat['name'])),
      foods:
          List<String>.from(json['menus']['foods'].map((food) => food['name'])),
      drinks: List<String>.from(
          json['menus']['drinks'].map((drink) => drink['name'])),
      customerReviews: List<CustomerReview>.from(
        json['customerReviews']
            .map((review) => CustomerReview.fromJson(review)),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'address': address,
      'pictureId': pictureId,
      'rating': rating,
      'description': description,
      'categories': jsonEncode(categories),
      'foods': jsonEncode(foods),
      'drinks': jsonEncode(drinks),
      'customerReviews': jsonEncode(customerReviews),
    };
  }

  factory RestaurantDetail.fromMap(Map<String, dynamic> map) {
    return RestaurantDetail(
      id: map['id'],
      name: map['name'],
      city: map['city'],
      address: map['address'],
      pictureId: map['pictureId'],
      rating: map['rating'],
      description: map['description'],
      categories: List<String>.from(jsonDecode(map['categories'])),
      foods: List<String>.from(jsonDecode(map['foods'])),
      drinks: List<String>.from(jsonDecode(map['drinks'])),
      customerReviews: List<CustomerReview>.from(
        jsonDecode(map['customerReviews'])
            .map((x) => CustomerReview.fromJson(x)),
      ),
    );
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

  factory CustomerReview.fromJson(Map<String, dynamic> json) {
    return CustomerReview(
      name: json['name'],
      review: json['review'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'review': review,
      'date': date,
    };
  }

  factory CustomerReview.fromMap(Map<String, dynamic> map) {
    return CustomerReview(
      name: map['name'],
      review: map['review'],
      date: map['date'],
    );
  }
}

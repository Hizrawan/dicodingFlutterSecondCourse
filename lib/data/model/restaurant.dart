class Restaurant {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final String? address; // bisa null
  final double rating;
  final List<Category> categories;
  final Menus menus;
  final List<CustomerReview> customerReviews;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    this.address,
    required this.rating,
    required this.categories,
    required this.menus,
    required this.customerReviews,
  });

  String get imageUrl =>
      "https://restaurant-api.dicoding.dev/images/large/$pictureId";

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json["id"]?.toString() ?? "",
      name: json["name"]?.toString() ?? "",
      description: json["description"]?.toString() ?? "",
      pictureId: json["pictureId"]?.toString() ?? "",
      city: json["city"]?.toString() ?? "",
      address: json["address"]?.toString(), // nullable
      rating: (json["rating"] as num?)?.toDouble() ?? 0.0,
      categories: (json["categories"] as List?)
              ?.map((e) => Category.fromJson(e))
              .toList() ??
          [],
      menus: json["menus"] != null
          ? Menus.fromJson(json["menus"])
          : Menus(foods: [], drinks: []),
      customerReviews: (json["customerReviews"] as List?)
              ?.map((e) => CustomerReview.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "pictureId": pictureId,
        "city": city,
        "address": address,
        "rating": rating,
        "categories": categories.map((e) => e.toJson()).toList(),
        "menus": menus.toJson(),
        "customerReviews": customerReviews.map((e) => e.toJson()).toList(),
      };
}

class Category {
  final String name;

  Category({required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(name: json["name"]?.toString() ?? "");
  }

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

class Menus {
  final List<MenuItem> foods;
  final List<MenuItem> drinks;

  Menus({required this.foods, required this.drinks});

  factory Menus.fromJson(Map<String, dynamic> json) {
    return Menus(
      foods: (json["foods"] as List?)
              ?.map((e) => MenuItem.fromJson(e))
              .toList() ??
          [],
      drinks: (json["drinks"] as List?)
              ?.map((e) => MenuItem.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        "foods": foods.map((e) => e.toJson()).toList(),
        "drinks": drinks.map((e) => e.toJson()).toList(),
      };
}

class MenuItem {
  final String name;

  MenuItem({required this.name});

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(name: json["name"]?.toString() ?? "");
  }

  Map<String, dynamic> toJson() => {
        "name": name,
      };
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
      name: json["name"]?.toString() ?? "",
      review: json["review"]?.toString() ?? "",
      date: json["date"]?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "review": review,
        "date": date,
      };
}

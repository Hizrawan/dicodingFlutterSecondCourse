
class Restaurant {
  final String id;
  final String name;
  final String description;
  final String city;
  final String address;
  final String pictureId;
  final double rating;
  final List<String> categories;
  final List<String> customerReviews;
  final List<String> menus;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.rating,
    required this.categories,
    required this.customerReviews,
    required this.menus,
  });
}

final List<Restaurant> restaurantList = [
  Restaurant(
    id: '1',
    name: 'The Gourmet Kitchen',
    description: 'A fine dining experience with international cuisine.',
    city: 'New York',
    address: '123 Main St, New York, NY',
    pictureId: 'https://example.com/images/restaurant1.jpg',
    rating: 4.8,
    categories: ['Fine Dining', 'International'],
    customerReviews: ['Amazing food!', 'Excellent service.'],
    menus: ['Steak', 'Lobster', 'Wine Selection'],
  ),
  Restaurant(
    id: '2',
    name: 'Pasta Paradise',
    description: 'Authentic Italian pasta dishes made fresh daily.',
    city: 'San Francisco',
    address: '456 Elm St, San Francisco, CA',
    pictureId: 'https://example.com/images/restaurant2.jpg',
    rating: 4.5,
    categories: ['Italian', 'Casual Dining'],
    customerReviews: ['Best pasta in town!', 'Cozy atmosphere.'],
    menus: ['Spaghetti Carbonara', 'Fettuccine Alfredo', 'Tiramisu'],
  ),
  // Add more restaurant entries as needed
];
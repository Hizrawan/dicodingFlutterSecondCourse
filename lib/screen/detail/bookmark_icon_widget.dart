import 'package:flutter/material.dart';
import 'package:restaurant_app/model/restaurant.dart';

class BookmarkIconWidget extends StatefulWidget {
  final Restaurant restaurant;
  const BookmarkIconWidget({super.key, required this.restaurant});

  @override
  State<BookmarkIconWidget> createState() => _BookmarkIconWidgetState();
}

class _BookmarkIconWidgetState extends State<BookmarkIconWidget> {
  late bool _isBookmarked;
  @override
  void initState() {
    final restaurantInList = bookmarkRestaurantList.where(
      (element) => element.id == widget.restaurant.id,
    );
    setState(() {
      if (restaurantInList.isNotEmpty) {
        _isBookmarked = true;
      } else {
        _isBookmarked = false;
      }
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() {
          if (_isBookmarked) {
            bookmarkRestaurantList.removeWhere(
              (element) => element.id == widget.restaurant.id,
            );
            _isBookmarked = false;
          } else {
            bookmarkRestaurantList.add(widget.restaurant);
            _isBookmarked = true;
          }
        });
      },
      icon: Icon(_isBookmarked ? Icons.bookmark : Icons.bookmark_outline),
    );
  }
}

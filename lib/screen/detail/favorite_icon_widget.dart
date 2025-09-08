import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/provider/detail/favorite_list_provider.dart';
import 'package:restaurant_app/provider/detail/favorite_icon_provider.dart';

class FavoriteIconWidget extends StatefulWidget {
  final Restaurant restaurant;

  const FavoriteIconWidget({super.key, required this.restaurant});

  @override
  State<FavoriteIconWidget> createState() => _FavoriteIconWidgetState();
}

class _FavoriteIconWidgetState extends State<FavoriteIconWidget> {
  @override
  void initState() {
    final favoriteListProvider = context.read<FavoriteListProvider>();
    final favoriteIconProvider = context.read<FavoriteIconProvider>();

    Future.microtask(() {
      final restaurantInList = favoriteListProvider.checkItemFavorite(
        widget.restaurant,
      );
      favoriteIconProvider.isFavoriteed = restaurantInList;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        final favoriteListProvider = context.read<FavoriteListProvider>();
        final favoriteIconProvider = context.read<FavoriteIconProvider>();
        final isFavoriteed = favoriteIconProvider.isFavoriteed;

        if (isFavoriteed) {
          favoriteListProvider.removeFavorite(widget.restaurant);
        } else {
          favoriteListProvider.addFavorite(widget.restaurant);
        }
        favoriteIconProvider.isFavoriteed = !isFavoriteed;
      },
      icon: Icon(
        context.watch<FavoriteIconProvider>().isFavoriteed
            ? Icons.favorite
            : Icons.favorite_outline,
      ),
    );
  }
}

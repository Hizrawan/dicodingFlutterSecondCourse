import 'package:flutter/material.dart';
import '../../models/restaurant.dart';

class RestaurantDetailPage extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantDetailPage({super.key, required this.restaurant});

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurant.title),
        backgroundColor: const Color(0xFF2d3e50),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.restaurant.title,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text(widget.restaurant.description,
                style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 24),
            Text("Progress (${(widget.restaurant.progress * 100).toInt()}%)",
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: widget.restaurant.progress,
              backgroundColor: Colors.grey.shade300,
              color: const Color(0xFF2d3e50),
              minHeight: 10,
            ),
            const SizedBox(height: 24),
            const Text("Restaurant Content",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: widget.restaurant.modules.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final module = widget.restaurant.modules[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFF2d3e50),
                        child: Text("${index + 1}",
                            style: const TextStyle(color: Colors.white)),
                      ),
                      title: Text(module.title),
                      subtitle: Text(module.content),
                      trailing: Icon(
                          module.isCompleted
                              ? Icons.check_circle
                              : Icons.arrow_forward_ios,
                          size: 16,
                          color: module.isCompleted
                              ? Colors.green
                              : Colors.grey),
                      onTap: ()  {
                        
                      }
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

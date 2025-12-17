import 'package:flutter/material.dart';

import 'tour.dart';

class TourDetailsPage extends StatelessWidget {
  final Tour tour;

  const TourDetailsPage({super.key, required this.tour});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tour.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${tour.country}, ${tour.city}',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Кількість днів: ${tour.days}'),
            Text('Ціна: \$${tour.price.toStringAsFixed(0)}'),
            const SizedBox(height: 16),
            Text(tour.description),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Функцію бронювання буде додано пізніше'),
                    ),
                  );
                },
                child: const Text('Забронювати'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

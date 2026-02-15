import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.calendarPlus),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildFeaturedEvent(context),
          const SizedBox(height: 24),
          Text(
            'Upcoming Events',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          ...List.generate(5, (index) => _buildEventCard(context, index)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const FaIcon(FontAwesomeIcons.plus),
        label: const Text('Create Event'),
      ),
    );
  }

  Widget _buildFeaturedEvent(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFFFD93D)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'FEATURED',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF6B6B),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SoulChat Music Festival 2024',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.calendar, color: Colors.white, size: 16),
                    const SizedBox(width: 8),
                    const Text(
                      'March 15, 2024',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(width: 20),
                    const FaIcon(FontAwesomeIcons.users, color: Colors.white, size: 16),
                    const SizedBox(width: 8),
                    const Text(
                      '5,000+ attending',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFFF6B6B),
                  ),
                  child: const Text('Join Event'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.primaries[index % Colors.primaries.length],
                    Colors.primaries[(index + 1) % Colors.primaries.length],
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${15 + index}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'MAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Event ${index + 1}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const FaIcon(FontAwesomeIcons.locationDot, size: 12),
                      const SizedBox(width: 4),
                      Text('Location ${index + 1}'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const FaIcon(FontAwesomeIcons.users, size: 12),
                      const SizedBox(width: 4),
                      Text('${(index + 1) * 100} attending'),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Join'),
            ),
          ],
        ),
      ),
    );
  }
}

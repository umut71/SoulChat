import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          IconButton(icon: const FaIcon(FontAwesomeIcons.plus), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(icon: const Icon(Icons.chevron_left), onPressed: () {}),
                      const Text('March 2024', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      IconButton(icon: const Icon(Icons.chevron_right), onPressed: () {}),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisSpacing: 8, crossAxisSpacing: 8),
                    itemCount: 35,
                    itemBuilder: (context, index) => Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: index == 15 ? Theme.of(context).primaryColor : null,
                        shape: BoxShape.circle,
                      ),
                      child: Text('${index + 1}', style: TextStyle(color: index == 15 ? Colors.white : null)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Today\'s Events', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...List.generate(5, (index) => Card(
            child: ListTile(
              leading: Container(
                width: 4,
                color: Colors.primaries[index % Colors.primaries.length],
              ),
              title: Text('Event ${index + 1}'),
              subtitle: Text('${9 + index}:00 AM - ${10 + index}:00 AM'),
              trailing: IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
            ),
          )),
        ],
      ),
    );
  }
}

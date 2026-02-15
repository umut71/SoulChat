import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All Friends'),
            Tab(text: 'Requests'),
            Tab(text: 'Suggestions'),
          ],
        ),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.userPlus),
            onPressed: () {
              // Add friend
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFriendsList(),
          _buildRequestsList(),
          _buildSuggestionsList(),
        ],
      ),
    );
  }

  Widget _buildFriendsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: 15,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.primaries[index % Colors.primaries.length],
              child: Text('F${index + 1}'),
            ),
            title: Text('Friend ${index + 1}'),
            subtitle: Text('Level ${index + 5} • Online'),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'message',
                  child: Row(
                    children: [
                      Icon(Icons.message),
                      SizedBox(width: 8),
                      Text('Message'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'profile',
                  child: Row(
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 8),
                      Text('View Profile'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'unfriend',
                  child: Row(
                    children: [
                      Icon(Icons.person_remove, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Unfriend', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () {
              // View friend profile
            },
          ),
        );
      },
    );
  }

  Widget _buildRequestsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.primaries[index % Colors.primaries.length],
              child: Text('R${index + 1}'),
            ),
            title: Text('User ${index + 1}'),
            subtitle: const Text('Wants to be friends'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.check, color: Colors.green),
                  onPressed: () {
                    // Accept request
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () {
                    // Decline request
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSuggestionsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.primaries[index % Colors.primaries.length],
              child: Text('S${index + 1}'),
            ),
            title: Text('Suggested User ${index + 1}'),
            subtitle: Text('${index + 5} mutual friends'),
            trailing: ElevatedButton.icon(
              onPressed: () {
                // Send friend request
              },
              icon: const Icon(Icons.person_add, size: 16),
              label: const Text('Add'),
            ),
          ),
        );
      },
    );
  }
}

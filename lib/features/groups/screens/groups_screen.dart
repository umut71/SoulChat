import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> with SingleTickerProviderStateMixin {
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
        title: const Text('Groups'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'My Groups'),
            Tab(text: 'Discover'),
            Tab(text: 'Suggested'),
          ],
        ),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
            onPressed: () {},
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMyGroups(),
          _buildDiscoverGroups(),
          _buildSuggestedGroups(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const FaIcon(FontAwesomeIcons.plus),
        label: const Text('Create Group'),
      ),
    );
  }

  Widget _buildMyGroups() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.primaries[index % Colors.primaries.length],
              child: FaIcon(
                _getGroupIcon(index),
                color: Colors.white,
              ),
            ),
            title: Text('My Group ${index + 1}'),
            subtitle: Text('${(index + 1) * 50} members • ${index + 3} online'),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'mute',
                  child: Row(
                    children: [
                      Icon(Icons.notifications_off),
                      SizedBox(width: 8),
                      Text('Mute'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'leave',
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Leave Group', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () {},
          ),
        );
      },
    );
  }

  Widget _buildDiscoverGroups() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: 20,
      itemBuilder: (context, index) {
        return Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.primaries[index % Colors.primaries.length],
                        Colors.primaries[(index + 1) % Colors.primaries.length],
                      ],
                    ),
                  ),
                  child: Center(
                    child: FaIcon(
                      _getGroupIcon(index),
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text(
                      'Group ${index + 1}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(index + 1) * 100} members',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text('Join'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSuggestedGroups() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.primaries[index % Colors.primaries.length],
                  child: FaIcon(
                    _getGroupIcon(index),
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Suggested Group ${index + 1}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${(index + 1) * 200} members',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Based on your interests',
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
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
      },
    );
  }

  IconData _getGroupIcon(int index) {
    final icons = [
      FontAwesomeIcons.users,
      FontAwesomeIcons.gamepad,
      FontAwesomeIcons.music,
      FontAwesomeIcons.cameraRetro,
      FontAwesomeIcons.book,
      FontAwesomeIcons.dumbbell,
      FontAwesomeIcons.paintbrush,
      FontAwesomeIcons.code,
    ];
    return icons[index % icons.length];
  }
}

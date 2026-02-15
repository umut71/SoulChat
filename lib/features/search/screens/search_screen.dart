import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search users, games, rooms...',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            setState(() {});
          },
        ),
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildFilterChip('All', 'all'),
          _buildFilterChip('Users', 'users'),
          _buildFilterChip('Games', 'games'),
          _buildFilterChip('Rooms', 'rooms'),
          _buildFilterChip('Streams', 'streams'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = value;
          });
        },
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchController.text.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Search for users, games, or rooms',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.primaries[index % Colors.primaries.length],
            child: Icon(
              _getIconForFilter(),
              color: Colors.white,
            ),
          ),
          title: Text('Result ${index + 1}'),
          subtitle: Text(_getSubtitleForFilter(index)),
          trailing: _getTrailingForFilter(),
          onTap: () {
            // Handle result tap
          },
        );
      },
    );
  }

  IconData _getIconForFilter() {
    switch (_selectedFilter) {
      case 'users':
        return Icons.person;
      case 'games':
        return Icons.sports_esports;
      case 'rooms':
        return Icons.mic;
      case 'streams':
        return Icons.videocam;
      default:
        return Icons.search;
    }
  }

  String _getSubtitleForFilter(int index) {
    switch (_selectedFilter) {
      case 'users':
        return 'Level ${index + 5} • ${index * 10} friends';
      case 'games':
        return '${(index + 1) * 100} players online';
      case 'rooms':
        return '${index + 3} people talking';
      case 'streams':
        return '${(index + 1) * 50} viewers';
      default:
        return 'Match found';
    }
  }

  Widget? _getTrailingForFilter() {
    if (_selectedFilter == 'users') {
      return ElevatedButton(
        onPressed: () {},
        child: const Text('Add'),
      );
    }
    return null;
  }
}

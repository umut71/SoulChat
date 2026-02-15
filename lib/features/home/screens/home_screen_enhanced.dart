import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animate_do/animate_do.dart';

class HomeScreenEnhanced extends StatelessWidget {
  const HomeScreenEnhanced({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.bolt, color: Color(0xFFFFD700)),
            const SizedBox(width: 8),
            Text(
              'SoulChat',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
            onPressed: () => context.push('/search'),
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.bell),
            onPressed: () => context.push('/notifications'),
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.gear),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInDown(child: _buildWelcomeCard(context)),
            const SizedBox(height: 20),
            FadeInUp(delay: const Duration(milliseconds: 100), child: _buildQuickActions(context)),
            const SizedBox(height: 20),
            FadeInUp(delay: const Duration(milliseconds: 200), child: _buildCreativeTools(context)),
            const SizedBox(height: 20),
            FadeInUp(delay: const Duration(milliseconds: 300), child: _buildStoriesSection(context)),
            const SizedBox(height: 20),
            FadeInUp(delay: const Duration(milliseconds: 400), child: _buildLiveNow(context)),
            const SizedBox(height: 20),
            FadeInUp(delay: const Duration(milliseconds: 500), child: _buildTrendingGames(context)),
            const SizedBox(height: 20),
            FadeInUp(delay: const Duration(milliseconds: 600), child: _buildVoiceRooms(context)),
            const SizedBox(height: 20),
            FadeInUp(delay: const Duration(milliseconds: 700), child: _buildEvents(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF00D9C0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome Back!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Ready to create, connect and explore?',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatChip('1,234', 'SoulCoins', FontAwesomeIcons.coins),
              const SizedBox(width: 12),
              _buildStatChip('Level 15', 'Progress', FontAwesomeIcons.trophy),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          FaIcon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _buildActionButton(context, 'Friends', FontAwesomeIcons.userGroup, const Color(0xFF6C63FF), '/friends'),
        _buildActionButton(context, 'Groups', FontAwesomeIcons.users, const Color(0xFF00D9C0), '/groups'),
        _buildActionButton(context, 'Live', FontAwesomeIcons.video, const Color(0xFFFF6584), '/live'),
        _buildActionButton(context, 'Voice', FontAwesomeIcons.microphone, const Color(0xFF00D9C0), '/voice-chat'),
        _buildActionButton(context, 'Games', FontAwesomeIcons.gamepad, const Color(0xFF6C63FF), '/games'),
        _buildActionButton(context, 'Market', FontAwesomeIcons.cartShopping, const Color(0xFFFFD700), '/marketplace'),
        _buildActionButton(context, 'Events', FontAwesomeIcons.calendar, const Color(0xFFFF6584), '/events'),
        _buildActionButton(context, 'Rewards', FontAwesomeIcons.gift, const Color(0xFFFFD700), '/rewards'),
      ],
    );
  }

  Widget _buildCreativeTools(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const FaIcon(FontAwesomeIcons.wand, color: Color(0xFF6C63FF)),
            const SizedBox(width: 8),
            Text(
              'Creative Studio',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildCreativeTool(context, 'Music Studio', FontAwesomeIcons.music, '/music-studio', Colors.purple),
              _buildCreativeTool(context, 'Image Editor', FontAwesomeIcons.image, '/image-editor', Colors.blue),
              _buildCreativeTool(context, 'Video Editor', FontAwesomeIcons.film, '/video-editor', Colors.red),
              _buildCreativeTool(context, 'AI Tools', FontAwesomeIcons.robot, '/ai-tools', Colors.green),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCreativeTool(BuildContext context, String title, IconData icon, String route, Color color) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.7)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(icon, color: Colors.white, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoriesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const FaIcon(FontAwesomeIcons.film, color: Color(0xFF6C63FF)),
                const SizedBox(width: 8),
                Text(
                  'Stories',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            TextButton(
              onPressed: () => context.push('/stories'),
              child: const Text('See All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (context, index) {
              return Container(
                width: 70,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.primaries[index % Colors.primaries.length],
                      Colors.primaries[(index + 1) % Colors.primaries.length],
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: index == 0
                      ? Border.all(color: const Color(0xFF6C63FF), width: 3)
                      : null,
                ),
                child: index == 0
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_circle, color: Colors.white),
                          SizedBox(height: 4),
                          Text('Your Story', style: TextStyle(color: Colors.white, fontSize: 10)),
                        ],
                      )
                    : Center(child: Text('${index}', style: const TextStyle(color: Colors.white, fontSize: 20))),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLiveNow(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const FaIcon(FontAwesomeIcons.video, color: Colors.red),
            const SizedBox(width: 8),
            Text(
              'Live Now',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            TextButton(onPressed: () => context.push('/live'), child: const Text('See All')),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                width: 160,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple.shade400, Colors.blue.shade400],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.circle, color: Colors.white, size: 8),
                            SizedBox(width: 4),
                            Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTrendingGames(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const FaIcon(FontAwesomeIcons.fire, color: Colors.orange),
            const SizedBox(width: 8),
            Text(
              'Trending Games',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            TextButton(onPressed: () => context.push('/games'), child: const Text('See All')),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                width: 100,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange.shade400, Colors.red.shade400],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: FaIcon(FontAwesomeIcons.gamepad, color: Colors.white, size: 32),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVoiceRooms(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const FaIcon(FontAwesomeIcons.microphone, color: Color(0xFF00D9C0)),
            const SizedBox(width: 8),
            Text(
              'Voice Rooms',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            TextButton(onPressed: () => context.push('/voice-chat'), child: const Text('See All')),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                width: 250,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.teal.shade400, Colors.cyan.shade400],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.white30,
                        shape: BoxShape.circle,
                      ),
                      child: const FaIcon(FontAwesomeIcons.microphone, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Room ${index + 1}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${(index + 1) * 5} people talking',
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEvents(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const FaIcon(FontAwesomeIcons.calendar, color: Colors.purple),
            const SizedBox(width: 8),
            Text(
              'Upcoming Events',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            TextButton(onPressed: () => context.push('/events'), child: const Text('See All')),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFFD93D)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            children: [
              FaIcon(FontAwesomeIcons.music, color: Colors.white, size: 32),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SoulChat Music Festival',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'March 15, 2024 • 5,000+ attending',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, String label, IconData icon, Color color, String route) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: FaIcon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

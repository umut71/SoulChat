import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class NFTMarketplaceScreen extends StatefulWidget {
  const NFTMarketplaceScreen({Key? key}) : super(key: key);

  @override
  State<NFTMarketplaceScreen> createState() => _NFTMarketplaceScreenState();
}

class _NFTMarketplaceScreenState extends State<NFTMarketplaceScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> nfts = [
    {'name': 'Soul Ape #1234', 'price': 5.5, 'image': '🦍', 'creator': 'SoulArt', 'likes': 234},
    {'name': 'Cyber Punk #567', 'price': 3.2, 'image': '🤖', 'creator': 'DigitalDreams', 'likes': 189},
    {'name': 'Soul Cat #890', 'price': 2.8, 'image': '🐱', 'creator': 'CatNation', 'likes': 456},
    {'name': 'Abstract Soul', 'price': 7.5, 'image': '🎨', 'creator': 'ModernArt', 'likes': 678},
  ];

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
        title: const Text('NFT Marketplace'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Explore'),
            Tab(text: 'My NFTs'),
            Tab(text: 'Create'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildExploreTab(),
          _buildMyNFTsTab(),
          _buildCreateTab(),
        ],
      ),
    );
  }

  Widget _buildExploreTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: nfts.length,
      itemBuilder: (context, index) {
        final nft = nfts[index];
        return FadeInUp(
          delay: Duration(milliseconds: index * 100),
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.purple.shade300, Colors.blue.shade300],
                      ),
                    ),
                    child: Center(
                      child: Text(nft['image'], style: const TextStyle(fontSize: 80)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(nft['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('${nft['price']} ETH', style: const TextStyle(color: Colors.purple)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMyNFTsTab() {
    return const Center(child: Text('My NFTs'));
  }

  Widget _buildCreateTab() {
    return const Center(child: Text('Create NFT'));
  }
}

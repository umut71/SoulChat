import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:soulchat/core/config/app_routes_list.dart';

class AllFeaturesScreen extends StatelessWidget {
  const AllFeaturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final paths = allRoutePaths;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tüm Özellikler (203)'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: paths.length,
        itemBuilder: (context, index) {
          final path = paths[index];
          final title = pathToTitle(path);
          return Card(
            child: InkWell(
              onTap: () => context.push(path),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Center(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

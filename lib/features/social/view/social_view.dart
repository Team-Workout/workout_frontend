import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'social_feed_view.dart';

class SocialView extends ConsumerWidget {
  const SocialView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SocialFeedView();
  }
}
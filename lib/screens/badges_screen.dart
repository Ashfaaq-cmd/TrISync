import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "../models/badge_model.dart";

class BadgesScreen extends StatelessWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final badgeProvider = context.watch<BadgeProvider>();
    final earned = badgeProvider.earnedBadges;
    final unearned = badgeProvider.unearnedBadges;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Badges',
          style: TextStyle(
            color: Color(0xFF023E8A),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${earned.length} / ${badgeProvider.allBadges.length}',
                style: const TextStyle(
                  color: Color(0xFF0077B6),
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── Progress bar ──────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF023E8A), Color(0xFF0077B6)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${earned.length} of ${badgeProvider.allBadges.length} badges earned',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: badgeProvider.allBadges.isEmpty
                        ? 0
                        : earned.length / badgeProvider.allBadges.length,
                    backgroundColor: Colors.white30,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                    minHeight: 10,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Earned badges ─────────────────────────────
          if (earned.isNotEmpty) ...[
            const Text(
              'Earned',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF023E8A),
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.78,
              ),
              itemCount: earned.length,
              itemBuilder: (context, i) => _BadgeTile(
                badge: earned[i],
                onTap: () => _showDetail(context, earned[i]),
              ),
            ),
            const SizedBox(height: 24),
          ],

          // ── Empty state ────────────────────────────────
          if (earned.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.workspace_premium,
                    size: 56,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'No badges yet',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF023E8A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Start logging workouts to earn your first badge.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),

          // ── Locked badges ─────────────────────────────
          if (unearned.isNotEmpty) ...[
            const Text(
              'Locked',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF023E8A),
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.78,
              ),
              itemCount: unearned.length,
              itemBuilder: (context, i) => _BadgeTile(
                badge: unearned[i],
                locked: true,
                onTap: () => _showDetail(context, unearned[i], locked: true),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showDetail(
    BuildContext context,
    AppBadge badge, {
    bool locked = false,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Badge circle
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: locked ? Colors.grey.shade300 : badge.color,
                shape: BoxShape.circle,
                boxShadow: locked
                    ? []
                    : [
                        BoxShadow(
                          color: badge.color.withValues(alpha: 0.35),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ],
              ),
              child: Icon(
                locked ? Icons.lock : badge.icon,
                color: locked ? Colors.grey : badge.iconColor,
                size: 38,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              badge.title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: locked ? Colors.grey : badge.color,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              badge.description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            if (!locked && badge.earnedDate != null) ...[
              const SizedBox(height: 8),
              Text(
                'Earned on ${badge.earnedDate!.day}/${badge.earnedDate!.month}/${badge.earnedDate!.year}',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF0077B6),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ── Badge tile in the grid ────────────────────────────────
class _BadgeTile extends StatelessWidget {
  final AppBadge badge;
  final bool locked;
  final VoidCallback onTap;

  const _BadgeTile({
    required this.badge,
    this.locked = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: locked ? Colors.grey.shade100 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: locked
                ? Colors.grey.shade300
                : badge.color.withValues(alpha: 0.35),
            width: 1.5,
          ),
          boxShadow: locked
              ? []
              : [
                  BoxShadow(
                    color: badge.color.withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Badge circle — mimics a real medal/badge shape
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: locked ? Colors.grey.shade300 : badge.color,
                shape: BoxShape.circle,
                boxShadow: locked
                    ? []
                    : [
                        BoxShadow(
                          color: badge.color.withValues(alpha: 0.3),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
              ),
              child: Icon(
                locked ? Icons.lock : badge.icon,
                color: locked ? Colors.grey.shade500 : badge.iconColor,
                size: 26,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                badge.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: locked ? Colors.grey : const Color(0xFF023E8A),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

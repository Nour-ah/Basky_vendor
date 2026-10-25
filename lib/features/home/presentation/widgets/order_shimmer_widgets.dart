import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Generic shimmer animation widget
class ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 12,
  });

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _animation = Tween<double>(
      begin: -1.5,
      end: 1.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value + 1, 0),
              colors: const [
                Color(0xFFE8E8E8),
                Color(0xFFF5F5F5),
                Color(0xFFE8E8E8),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Shimmer for a single order card placeholder
class OrderCardShimmer extends StatelessWidget {
  const OrderCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const ShimmerBox(width: 40, height: 40, borderRadius: 20),
              const SizedBox(width: 12),
              ShimmerBox(
                width: MediaQuery.of(context).size.width * 0.35,
                height: 18,
              ),
              const Spacer(),
              const ShimmerBox(width: 72, height: 28, borderRadius: 14),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.greyLight),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerBox(
                width: MediaQuery.of(context).size.width * 0.3,
                height: 14,
              ),
              const ShimmerBox(width: 80, height: 14),
            ],
          ),
        ],
      ),
    );
  }
}

/// Shimmer for order stats row
class OrderStatsShimmer extends StatelessWidget {
  const OrderStatsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: ShimmerBox(
              width: double.infinity,
              height: 32,
              borderRadius: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ShimmerBox(
              width: double.infinity,
              height: 32,
              borderRadius: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ShimmerBox(
              width: double.infinity,
              height: 32,
              borderRadius: 24,
            ),
          ),
        ],
      ),
    );
  }
}

/// Full list of order card shimmers
class OrderListShimmer extends StatelessWidget {
  final int count;
  const OrderListShimmer({super.key, this.count = 5});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(count, (_) => const OrderCardShimmer()),
    );
  }
}

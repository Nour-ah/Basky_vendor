import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../theme/app_colors.dart';

/// Shared skeleton loading UIs powered by `skeletonizer`.
class AppSkeletonLoading {
  AppSkeletonLoading._();

  static Widget home() => const HomeSkeleton();

  static Widget ordersList({int count = 5}) => OrdersListSkeleton(count: count);

  static Widget orderDetails() => const OrderDetailsSkeleton();

  static Widget branchesList({int count = 4}) =>
      BranchesListSkeleton(count: count);
}

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Row(
            children: const [
              Expanded(child: _StatCardBone()),
              SizedBox(width: 16),
              Expanded(child: _StatCardBone()),
            ],
          ),
          const SizedBox(height: 24),
          const _FilterTabsBone(),
          const SizedBox(height: 12),
          const _StatsRowBone(),
          const SizedBox(height: 16),
          ...List.generate(4, (_) => const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: _OrderCardBone(),
              )),
        ],
      ),
    );
  }
}

class OrdersListSkeleton extends StatelessWidget {
  const OrdersListSkeleton({super.key, this.count = 5});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: count,
        separatorBuilder: (_, _) => const SizedBox(height: 16),
        itemBuilder: (_, _) => const _OrderCardBone(),
      ),
    );
  }
}

class OrderDetailsSkeleton extends StatelessWidget {
  const OrderDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView(
        padding: const EdgeInsets.all(16),
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          _CardBone(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Bone.text(width: 72),
                    SizedBox(height: 8),
                    Bone.text(width: 120, fontSize: 18),
                  ],
                ),
                Bone.button(width: 88, height: 28),
              ],
            ),
          ),
          SizedBox(height: 16),
          _CardBone(
            child: Row(
              children: [
                Bone.circle(size: 48),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Bone.text(width: 140),
                      SizedBox(height: 8),
                      Bone.text(width: 100),
                      SizedBox(height: 8),
                      Bone.text(width: 180),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          _CardBone(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Bone.text(width: 100),
                SizedBox(height: 8),
                Bone.text(width: 160),
                SizedBox(height: 8),
                Bone.text(width: 200),
              ],
            ),
          ),
          SizedBox(height: 12),
          _CardBone(
            child: Column(
              children: [
                _ItemRowBone(),
                SizedBox(height: 12),
                _ItemRowBone(),
                SizedBox(height: 12),
                _ItemRowBone(),
              ],
            ),
          ),
          SizedBox(height: 12),
          _CardBone(
            child: Column(
              children: [
                Bone.text(width: double.infinity),
                SizedBox(height: 10),
                Bone.text(width: double.infinity),
                SizedBox(height: 10),
                Bone.text(width: 160),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BranchesListSkeleton extends StatelessWidget {
  const BranchesListSkeleton({super.key, this.count = 4});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: count + 1,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index == 0) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Bone.text(width: 220),
            );
          }
          return const _BranchCardBone();
        },
      ),
    );
  }
}

class _StatCardBone extends StatelessWidget {
  const _StatCardBone();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Bone.icon(size: 28),
          Spacer(),
          Bone.text(width: 72),
          SizedBox(height: 8),
          Bone.text(width: 48, fontSize: 18),
        ],
      ),
    );
  }
}

class _FilterTabsBone extends StatelessWidget {
  const _FilterTabsBone();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, _) => const Bone.button(width: 72, height: 32),
      ),
    );
  }
}

class _StatsRowBone extends StatelessWidget {
  const _StatsRowBone();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: Bone.button(height: 32)),
        SizedBox(width: 12),
        Expanded(child: Bone.button(height: 32)),
        SizedBox(width: 12),
        Expanded(child: Bone.button(height: 32)),
      ],
    );
  }
}

class _OrderCardBone extends StatelessWidget {
  const _OrderCardBone();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Bone.text(width: 140)),
              Bone.button(width: 72, height: 28),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Bone.text(width: 100),
              Bone.text(width: 80),
            ],
          ),
        ],
      ),
    );
  }
}

class _BranchCardBone extends StatelessWidget {
  const _BranchCardBone();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Bone(
            width: double.infinity,
            height: 150,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Bone.text(width: 160, fontSize: 16),
                SizedBox(height: 10),
                Bone.text(width: 220),
                SizedBox(height: 8),
                Bone.text(width: 120),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardBone extends StatelessWidget {
  const _CardBone({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

class _ItemRowBone extends StatelessWidget {
  const _ItemRowBone();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Bone.square(size: 48),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Bone.text(width: 140),
              SizedBox(height: 6),
              Bone.text(width: 80),
            ],
          ),
        ),
        Bone.text(width: 48),
      ],
    );
  }
}

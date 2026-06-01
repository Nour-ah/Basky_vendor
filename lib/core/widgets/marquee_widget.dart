import 'package:flutter/material.dart';

class MarqueeWidget extends StatefulWidget {
  final Widget child;
  final Axis direction;
  final Duration animationDuration;
  final Duration backDuration;
  final Duration pauseDuration;

  const MarqueeWidget({
    super.key,
    required this.child,
    this.direction = Axis.horizontal,
    this.animationDuration = const Duration(milliseconds: 3000),
    this.backDuration = const Duration(milliseconds: 800),
    this.pauseDuration = const Duration(milliseconds: 1500),
  });

  @override
  State<MarqueeWidget> createState() => _MarqueeWidgetState();
}

class _MarqueeWidgetState extends State<MarqueeWidget> {
  late ScrollController _scrollController;
  bool _isScrolling = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scroll();
    });
  }

  @override
  void dispose() {
    _isScrolling = false;
    _scrollController.dispose();
    super.dispose();
  }

  void _scroll() async {
    _isScrolling = true;
    while (_isScrolling && mounted) {
      await Future.delayed(widget.pauseDuration);
      if (!mounted || !_isScrolling) return;

      if (_scrollController.hasClients) {
        final maxScrollExtent = _scrollController.position.maxScrollExtent;
        if (maxScrollExtent > 0) {
          await _scrollController.animateTo(
            maxScrollExtent,
            duration: widget.animationDuration,
            curve: Curves.linear,
          );
        }
      }

      await Future.delayed(widget.pauseDuration);
      if (!mounted || !_isScrolling) return;

      if (_scrollController.hasClients) {
        final maxScrollExtent = _scrollController.position.maxScrollExtent;
        if (maxScrollExtent > 0) {
          await _scrollController.animateTo(
            0.0,
            duration: widget.backDuration,
            curve: Curves.easeOut,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      controller: _scrollController,
      scrollDirection: widget.direction,
      child: widget.child,
    );
  }
}

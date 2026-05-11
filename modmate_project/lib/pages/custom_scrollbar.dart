// lib/widgets/custom_scrollbar.dart

import 'package:flutter/material.dart';

class CustomScrollbar extends StatefulWidget {
  final ScrollController controller;
  final Widget child;
  final double thickness;
  final Color color;
  final double minThumbHeight;

  const CustomScrollbar({
    super.key,
    required this.controller,
    required this.child,
    this.thickness = 5,
    this.color = Colors.white,
    this.minThumbHeight = 40,
  });

  @override
  State<CustomScrollbar> createState() => _CustomScrollbarState();
}

class _CustomScrollbarState extends State<CustomScrollbar> {
  double _thumbPosition = 0;
  double _thumbHeight = 40;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateThumb);
  }

  void _updateThumb() {
    if (!widget.controller.hasClients) return;
    final pos = widget.controller.position;
    final viewportH = pos.viewportDimension;
    final maxScroll = pos.maxScrollExtent;

    if (maxScroll <= 0) return;

    final thumbH = (viewportH / (maxScroll + viewportH)) * viewportH;
    final thumbPos = (pos.pixels / maxScroll) * (viewportH - thumbH);

    setState(() {
      _thumbHeight = thumbH.clamp(widget.minThumbHeight, viewportH);
      _thumbPosition = thumbPos.clamp(0, viewportH - _thumbHeight);
      _visible = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _visible = false);
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateThumb);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned(
          right: 4,
          top: 0,
          bottom: 0,
          child: AnimatedOpacity(
            opacity: _visible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: SizedBox(
              width: widget.thickness,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      Positioned(
                        top: _thumbPosition,
                        child: Container(
                          width: widget.thickness,
                          height: _thumbHeight,
                          decoration: BoxDecoration(
                            color: widget.color,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
import 'dart:async';
import 'package:flutter/material.dart';

class CountdownWidget extends StatefulWidget {
  final DateTime targetDate;
  const CountdownWidget({super.key, required this.targetDate});

  @override
  State<CountdownWidget> createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget> {
  late Timer _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _calculateRemaining();
    _timer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => _calculateRemaining(),
    );
  }

  @override
  void didUpdateWidget(CountdownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targetDate != widget.targetDate) {
      _calculateRemaining();
    }
  }

  void _calculateRemaining() {
    if (!mounted) return;
    final now = DateTime.now();
    setState(() {
      _remaining = widget.targetDate.isAfter(now)
          ? widget.targetDate.difference(now)
          : Duration.zero;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_remaining == Duration.zero) {
      // ✅ FIX 3: const eklendi (prefer_const_constructors - satır 57)
      return const _StatusBadge(
        color: Colors.green,
        icon: Icons.flight_takeoff,
        label: 'Seyahat başladı!',
      );
    }

    final days = _remaining.inDays;
    final hours = _remaining.inHours % 24;
    final minutes = _remaining.inMinutes % 60;

    final Color badgeColor;
    if (days > 7) {
      badgeColor = theme.colorScheme.primary;
    } else if (days > 1) {
      badgeColor = Colors.orangeAccent;
    } else {
      badgeColor = Colors.redAccent;
    }

    final String timeText;
    if (days > 0) {
      timeText = '$days gün $hours saat kaldı';
    } else if (hours > 0) {
      timeText = '$hours saat $minutes dakika kaldı';
    } else {
      timeText = '$minutes dakika kaldı';
    }

    return _StatusBadge(
      color: badgeColor,
      icon: Icons.timer_outlined,
      label: timeText,
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;

  const _StatusBadge({
    required this.color,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        // ✅ FIX 4: withOpacity → withValues(alpha:) (satır 113)
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        // ✅ FIX 5: withOpacity → withValues(alpha:) (satır 115)
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

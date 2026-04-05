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
    _timer = Timer.periodic(const Duration(minutes: 1), (_) => _calculateRemaining());
  }

  void _calculateRemaining() {
    final now = DateTime.now();
    if (widget.targetDate.isAfter(now)) {
      setState(() => _remaining = widget.targetDate.difference(now));
    } else {
      setState(() => _remaining = Duration.zero);
    }
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
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(8)),
        child: const Text('Seyahat basladi!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      );
    }

    final days = _remaining.inDays;
    final hours = _remaining.inHours % 24;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: theme.colorScheme.tertiaryContainer, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer, size: 16, color: theme.colorScheme.onTertiaryContainer),
          const SizedBox(width: 6),
          Text(
            days > 0 ? '$days gun $hours saat kaldi' : '$hours saat kaldi',
            style: TextStyle(color: theme.colorScheme.onTertiaryContainer, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

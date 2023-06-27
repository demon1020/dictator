import 'package:dictator/app_config/theme.dart';
import 'package:flutter/material.dart';

class AppSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  AppSlider({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: AppTheme.primary,
        thumbColor: AppTheme.primary,
        overlayColor: AppTheme.primary.withOpacity(0.5),
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 20),
      ),
      child: Slider(
        value: value.toDouble(),
        min: 0.0,
        max: 1,
        onChanged: onChanged,
      ),
    );
  }
}
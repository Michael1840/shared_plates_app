import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/methods.dart';

class SmartPriceSlider extends StatelessWidget {
  final int step;
  final double maxPrice;
  final double sliderValue;
  final void Function(double v, int m) onChanged;
  const SmartPriceSlider({
    super.key,
    required this.step,
    required this.maxPrice,
    required this.sliderValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            valueIndicatorTextStyle: context.myTextStyle(
              color: context.white,
              size: 12,
              weight: Weights.medium,
            ),
            showValueIndicator: _calculatedPrice == maxPrice
                ? ShowValueIndicator.onDrag
                : ShowValueIndicator.alwaysVisible,
            valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
          ),
          child: Slider(
            value: sliderValue,
            min: 0.0,
            max: 1.0,
            label:
                '${Formatter.currencyFormat(_calculatedPrice.toString())}${_calculatedPrice == maxPrice ? '+' : ''}',
            onChanged: (v) {
              onChanged(v, _calculatedPrice);
            },
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AppText.secondary(text: 'R0', size: 10),
              AppText.secondary(
                text: '${Formatter.currencyFormat(maxPrice.toString())}+',
                size: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }

  int get _calculatedPrice {
    double rawPrice = maxPrice * pow(sliderValue, 2);

    return (rawPrice / step).round() * step;
  }
}

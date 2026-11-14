import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/widgets/dot_grid_background.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';

class SplashPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DotGridBackground(
        child: Center(child: Paprika(size: 140, delay: Duration.zero)),
      ),
    );
  }
}

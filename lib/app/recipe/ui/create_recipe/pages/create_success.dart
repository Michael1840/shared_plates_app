import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/ui/custom/buttons/wide_text_button.dart';
import '../../../../core/ui/layouts/page_container.dart';

class CreateSuccessPage extends StatelessWidget {
  final void Function() onDone;
  const CreateSuccessPage({super.key, required this.onDone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 40,
        leadingWidth: 6,
        leading: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // MyIconButton(
            //   icon: MyIcons.chevron_left,
            //   onTap: () {
            //     context.pop();
            //   },
            // ).paddingLeft(20),
          ],
        ),
      ),
      body: PageContainer(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const AppText.heading(text: 'Recipe Created!'),

            LottieBuilder.asset('assets/animations/Trophy.json', repeat: false),

            WideTextButton(text: 'Done', onTap: onDone),
          ],
        ),
      ),
    );
  }
}

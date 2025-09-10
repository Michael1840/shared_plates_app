import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import '../../../core/ui/custom/buttons/wide_text_button.dart';
import '../../../core/ui/custom/fields/my_form_field.dart';
import '../../../core/ui/custom/icons/my_icons.dart';
import '../../../core/utils/extensions.dart';

class LoginSheet extends StatefulWidget {
  const LoginSheet({super.key});

  @override
  State<LoginSheet> createState() => _LoginSheetState();
}

class _LoginSheetState extends State<LoginSheet> {
  final TextEditingController _emailCont = TextEditingController();
  final TextEditingController _passCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 20,
        children: [
          const Column(
            spacing: 8,
            children: [
              AppText.heading(text: 'Welcome Back'),
              AppText.secondary(
                text: 'Back for seconds? Let\'s get cooking!',
                size: 12,
              ),
            ],
          ),
          MyFormField(
            controller: _emailCont,
            hint: 'Your email',
            title: 'Email',
            icon: MyIcons.mail,
          ),
          MyFormField(
            controller: _passCont,
            hint: 'Your password',
            title: 'Password',
            icon: MyIcons.lock,
          ),
          WideTextButton(text: 'Login', onTap: () {}),
          Row(
            spacing: 20,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: 1,
                  color: context.textSecondary,
                ),
              ),
              const AppText.secondary(text: ' OR '),
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: 1,
                  color: context.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

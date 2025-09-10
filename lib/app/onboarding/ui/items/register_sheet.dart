import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import '../../../core/ui/custom/buttons/wide_text_button.dart';
import '../../../core/ui/custom/fields/my_form_field.dart';
import '../../../core/ui/custom/icons/my_icons.dart';
import '../../../core/utils/extensions.dart';

class RegisterSheet extends StatefulWidget {
  const RegisterSheet({super.key});

  @override
  State<RegisterSheet> createState() => _RegisterSheetState();
}

class _RegisterSheetState extends State<RegisterSheet> {
  final TextEditingController _displayCont = TextEditingController();
  final TextEditingController _emailCont = TextEditingController();
  final TextEditingController _passCont = TextEditingController();
  final TextEditingController _pass2Cont = TextEditingController();

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
              AppText.heading(text: 'Let\'s Get You Started'),
              AppText.secondary(
                text: 'Your profile, your vibe — start here.',
                size: 12,
              ),
            ],
          ),
          MyFormField(
            controller: _displayCont,
            hint: 'Your display name',
            title: 'Display Name',
            icon: MyIcons.user_02,
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
          MyFormField(
            controller: _pass2Cont,
            hint: 'Your password again',
            title: 'Confirm Password',
            icon: MyIcons.lock,
          ),
          WideTextButton(text: 'Sign Up', onTap: () {}),
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

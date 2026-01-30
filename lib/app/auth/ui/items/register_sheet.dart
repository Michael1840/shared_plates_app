import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import '../../../core/ui/custom/buttons/circle_svg_button.dart';
import '../../../core/ui/custom/buttons/wide_text_button.dart';
import '../../../core/ui/custom/fields/my_form_field.dart';
import '../../../core/ui/custom/icons/my_icons.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/extensions.dart';

class RegisterSheet extends StatefulWidget {
  final void Function() onTap;
  const RegisterSheet({super.key, required this.onTap});

  @override
  State<RegisterSheet> createState() => _RegisterSheetState();
}

class _RegisterSheetState extends State<RegisterSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _displayCont = TextEditingController();
  final TextEditingController _emailCont = TextEditingController();
  final TextEditingController _passCont = TextEditingController();

  bool _isHidden = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
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
              isRequired: true,
              icon: MyIcons.user_02,
            ),
            MyFormField(
              controller: _emailCont,
              hint: 'Your email',
              title: 'Email',
              icon: MyIcons.mail,
              isRequired: true,
              textAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
            ),
            MyFormField(
              controller: _passCont,
              hint: 'Create your password',
              title: 'Create Password',
              icon: MyIcons.lock,
              isRequired: true,
              obscureText: _isHidden,
              trailingIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _isHidden = !_isHidden;
                  });
                },
                icon: Icon(_isHidden ? MyIcons.hide : MyIcons.show),
              ),
              textAction: TextInputAction.go,
              onSubmit: (_) {},
            ),
            WideTextButton(text: 'Sign Up', onTap: () {}),
            // const SizedBox(),
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
            // const SizedBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 12,
              children: [
                CircleSvgButton(asset: googleSvg, onTap: () {}),
                CircleSvgButton(asset: appleSvg, onTap: () {}),
              ],
            ),
            const SizedBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText.primary(
                  text: 'Already have an account? ',
                  alignment: TextAlign.center,
                  color: context.white,
                  size: 12,
                ),
                AppText.heading(
                  text: 'Log In',
                  alignment: TextAlign.center,
                  color: context.green,
                  size: 12,
                ).onTap(widget.onTap),
              ],
            ),
          ],
        ),
      ),
    ).onTap(() {
      FocusScope.of(context).unfocus();
    });
  }
}

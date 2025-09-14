import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/theme.dart';
import '../../../core/ui/custom/buttons/circle_svg_button.dart';
import '../../../core/ui/custom/buttons/wide_text_button.dart';
import '../../../core/ui/custom/fields/my_form_field.dart';
import '../../../core/ui/custom/icons/my_icons.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/extensions.dart';
import '../../blocs/user_bloc/user_bloc.dart';

class LoginSheet extends StatefulWidget {
  const LoginSheet({super.key});

  @override
  State<LoginSheet> createState() => _LoginSheetState();
}

class _LoginSheetState extends State<LoginSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailCont = TextEditingController();
  final TextEditingController _passCont = TextEditingController();

  bool _isHidden = true;

  void _login() {
    if (_formKey.currentState!.validate()) {
      context.read<UserBloc>().add(
        UserLogin(
          email: _emailCont.trimmedText,
          password: _passCont.trimmedText,
        ),
      );
    }
  }

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
              isRequired: true,
              textAction: TextInputAction.next,
            ),
            MyFormField(
              controller: _passCont,
              hint: 'Your password',
              title: 'Password',
              icon: MyIcons.lock,
              isRequired: true,
              obscureText: _isHidden,
              textAction: TextInputAction.go,
              onSubmit: (_) {
                _login();
              },
              trailingIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _isHidden = !_isHidden;
                  });
                },
                icon: Icon(_isHidden ? MyIcons.hide : MyIcons.show),
              ),
            ),
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                return WideTextButton(
                  text: 'Login',
                  onTap: _login,
                  isLoading: state is UserLoading,
                );
              },
            ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 12,
              children: [
                CircleSvgButton(asset: googleSvg, onTap: () {}),
                CircleSvgButton(asset: appleSvg, onTap: () {}),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

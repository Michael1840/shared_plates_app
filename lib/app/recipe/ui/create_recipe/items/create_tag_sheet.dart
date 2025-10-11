import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/ui/custom/buttons/wide_text_button.dart';
import '../../../../core/ui/custom/fields/my_form_field.dart';
import '../../../../core/utils/extensions.dart';
import '../../../bloc/create_recipe/create_recipe_cubit.dart';

class CreateTagSheet extends StatefulWidget {
  final void Function(String i) onConfirm;
  final CreateRecipeCubit cubit;
  final int currentIndex;
  const CreateTagSheet({
    super.key,
    required this.onConfirm,
    required this.cubit,
    required this.currentIndex,
  });

  @override
  State<CreateTagSheet> createState() => _CreateTagSheetState();
}

class _CreateTagSheetState extends State<CreateTagSheet> {
  final TextEditingController _tagCont = TextEditingController();

  void _addTag() {
    final String tag = _tagCont.trimmedText;

    if (tag.isEmpty) {
      return;
    }

    widget.onConfirm(tag);

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        const AppText.heading(text: 'Add Tag', size: 18),
        const SizedBox(),
        MyFormField(
          hint: 'Enter your tag',
          title: 'Tag',
          controller: _tagCont,
          radius: 24,
        ),
        const SizedBox(),
        WideTextButton(text: 'Add Tag', onTap: _addTag),
      ],
    );
  }
}

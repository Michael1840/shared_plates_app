import 'package:flutter/material.dart';

import '../icons/my_icons.dart';
import 'my_form_field.dart';

class SearchField extends StatelessWidget {
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  const SearchField({super.key, this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return MyFormField(
      icon: MyIcons.search_magnifying_glass,
      hasLabel: false,
      customPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      hint: 'Search',
      title: '',
      onChanged: onChanged,
      controller: controller,
      radius: 100,
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_plates_app/app/di.dart';
import 'package:shared_plates_app/core/domain/models/profile.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/widgets/buttons.dart';
import 'package:shared_plates_app/core/widgets/snackbars.dart';
import 'package:shared_plates_app/core/widgets/sp_text_field.dart';
import 'package:shared_plates_app/features/profile/data/profile_repository.dart';
import 'package:shared_plates_app/features/profile/presentation/bloc/edit_profile_cubit.dart';

class EditProfileSheet extends StatelessWidget {
  const new({required this.profile, super.key});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          EditProfileCubit(profiles: sl<ProfileRepository>(), profile: profile),
      child: _EditProfileForm(profile: profile),
    );
  }
}

class _EditProfileForm extends StatefulWidget {
  const new({required this.profile});

  final Profile profile;

  @override
  State<_EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<_EditProfileForm> {
  late final TextEditingController _name = TextEditingController(
    text: widget.profile.displayName,
  );
  late final TextEditingController _username = TextEditingController(
    text: widget.profile.username,
  );
  late final TextEditingController _city = TextEditingController(
    text: widget.profile.city ?? '',
  );
  late final TextEditingController _bio = TextEditingController(
    text: widget.profile.bio ?? '',
  );

  @override
  void dispose() {
    _name.dispose();
    _username.dispose();
    _city.dispose();
    _bio.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final cubit = context.read<EditProfileCubit>();
    final ok = await cubit.save();
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop();
      context.showSnackBarMessage('Profile saved.');
    } else {
      final error = cubit.state.save.error;
      if (error != null) context.showSnackBarError(error);
    }
  }

  static (String?, FieldStatus) _usernameHelp(UsernameCheck check) =>
      switch (check) {
        UsernameCheck.unchanged => (null, FieldStatus.idle),
        UsernameCheck.invalid => (
          '3–24 characters: lowercase letters, numbers, dots or underscores.',
          FieldStatus.error,
        ),
        UsernameCheck.checking => ('Checking…', FieldStatus.idle),
        UsernameCheck.free => ("It's yours.", FieldStatus.success),
        UsernameCheck.taken => ('Someone has that one.', FieldStatus.error),
        UsernameCheck.unknown => (
          "Couldn't check right now. We'll try when you save.",
          FieldStatus.idle,
        ),
      };

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EditProfileCubit>().state;
    final cubit = context.read<EditProfileCubit>();
    final (help, status) = _usernameHelp(state.check);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: Spacing.m,
          children: [
            const AppText(text: 'Edit profile', config: FontConfigs.h2),
            SpTextField(
              label: 'Name',
              controller: _name,
              textCapitalization: TextCapitalization.words,
              inputFormatters: [LengthLimitingTextInputFormatter(60)],
              onChanged: cubit.setDisplayName,
            ),
            SpTextField(
              label: 'Username',
              controller: _username,
              prefixText: '@',
              autocorrect: false,
              helper: help,
              status: status,
              inputFormatters: [LengthLimitingTextInputFormatter(24)],
              onChanged: cubit.setUsername,
            ),
            SpTextField(
              label: 'City',
              hint: 'Optional',
              controller: _city,
              textCapitalization: TextCapitalization.words,
              inputFormatters: [LengthLimitingTextInputFormatter(60)],
              onChanged: cubit.setCity,
            ),
            SpTextField(
              label: 'About you',
              hint: 'Budget suppers and anything my gran made',
              helper: '${state.bio.length}/160',
              controller: _bio,
              inputFormatters: [LengthLimitingTextInputFormatter(160)],
              onChanged: cubit.setBio,
            ),
            PrimaryButton(
              label: 'Save',
              busyLabel: 'Saving…',
              isBusy: state.save.isInProgress,
              onTap: state.canSave ? () => unawaited(_save()) : null,
            ),
          ],
        ),
      ),
    );
  }
}

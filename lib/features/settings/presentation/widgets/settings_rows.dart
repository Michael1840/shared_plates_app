import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/motion.dart';
import 'package:shared_plates_app/core/theme/palette.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/buttons.dart';
import 'package:shared_plates_app/core/widgets/motion/pressable.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';
import 'package:shared_plates_app/core/widgets/sp_chip.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/features/profile/domain/avoid_option.dart';
import 'package:shared_plates_app/features/settings/presentation/bloc/settings_cubit.dart';

class SettingsGroup extends StatelessWidget {
  const new({required this.title, required this.rows, super.key});

  final String title;
  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Spacing.xs,
      children: [
        Semantics(
          header: true,
          child: AppText(text: title, config: FontConfigs.h3),
        ).paddingOnly(left: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.m),
          decoration: BoxDecoration(
            color: context.container,
            borderRadius: BorderRadius.circular(Rounding.row),
          ),
          child: Column(
            children: [
              for (final (i, row) in rows.indexed)
                DecoratedBox(
                  decoration: BoxDecoration(
                    border: i == rows.length - 1
                        ? null
                        : Border(
                            bottom: BorderSide(color: context.sp.progressTrack),
                          ),
                  ),
                  child: row,
                ),
            ],
          ),
        ),
        const SizedBox(height: Spacing.l),
      ],
    );
  }
}

class LinkRow extends StatelessWidget {
  const new({required this.label, super.key, this.value, this.onTap});

  final String label;
  final String? value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final v = value;
    final row = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 56),
      child: Row(
        spacing: Spacing.s,
        children: [
          AppText(
            text: label,
            config: FontConfigs.body2,
            weight: FontWeight.w500,
          ),
          AppText.secondary(
            text: v ?? '',
            config: FontConfigs.body3,
            color: context.textMuted,
            align: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ).expand(),
          if (onTap != null)
            SpIcon(SpIcons.chevronRight, size: 18, color: context.sp.chevron),
        ],
      ),
    );
    final tap = onTap;
    if (tap == null) {
      return Semantics(
        label: [label, ?v].join(', '),
        excludeSemantics: true,
        child: row,
      );
    }
    return Pressable(
      onTap: tap,
      semanticLabel: [label, ?v].join(', '),
      child: row,
    );
  }
}

class ToggleRow extends StatelessWidget {
  const new({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
    this.sub,
  });

  final String label;
  final String? sub;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final detail = sub;
    return MergeSemantics(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 56),
        child: Row(
          spacing: Spacing.s,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2,
              children: [
                AppText(
                  text: label,
                  config: FontConfigs.body2,
                  weight: FontWeight.w500,
                ),
                if (detail != null)
                  AppText.secondary(
                    text: detail,
                    config: FontConfigs.sublabel1,
                    color: context.textMuted,
                  ),
              ],
            ).paddingSymmetric(vertical: 10).expand(),
            Switch(
              value: value,
              onChanged: onChanged,
              activeTrackColor: context.herb,
              activeThumbColor: Palette.card,
              inactiveTrackColor: context.sp.handle,
              inactiveThumbColor: Palette.card,
              trackOutlineColor: const WidgetStatePropertyAll(
                Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SegmentRow<T> extends StatelessWidget {
  const new({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    super.key,
  });

  final String label;
  final T value;
  final Map<T, String> options;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Spacing.xs,
      children: [
        AppText(
          text: label,
          config: FontConfigs.body2,
          weight: FontWeight.w500,
        ),
        Semantics(
          label: label,
          container: true,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: context.sp.avoidFill,
              borderRadius: BorderRadius.circular(Rounding.chip + 2),
            ),
            child: Row(
              spacing: 4,
              children: [
                for (final MapEntry(key: option, value: text)
                    in options.entries)
                  Semantics(
                    inMutuallyExclusiveGroup: true,
                    checked: option == value,
                    child: Pressable(
                      onTap: () => onChanged(option),
                      child: AnimatedContainer(
                        duration: context.motion(Motion.small),
                        height: 38,
                        decoration: BoxDecoration(
                          color: option == value
                              ? context.textPrimary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(
                            Rounding.chip - 2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: AppText(
                          text: text,
                          config: FontConfigs.sublabel1,
                          weight: option == value
                              ? FontWeight.w700
                              : FontWeight.w600,
                          color: option == value
                              ? context.background
                              : context.textSecondary,
                        ),
                      ),
                    ),
                  ).expand(),
              ],
            ),
          ),
        ),
      ],
    ).paddingSymmetric(vertical: Spacing.s);
  }
}

class AvoidSheet extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final avoid = context.select<SettingsCubit, Set<AvoidOption>>(
      (c) => c.state.avoid,
    );
    final cubit = context.read<SettingsCubit>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Spacing.s,
      children: [
        const AppText(text: 'Hide recipes with', config: FontConfigs.h2),
        const AppText.secondary(
          text: "We'll keep these out of Discover and search.",
          config: FontConfigs.body3,
        ),
        Wrap(
          spacing: Spacing.xs,
          runSpacing: Spacing.xs,
          children: [
            for (final option in AvoidOption.values)
              SpChip(
                label: option.label,
                tone: ChipTone.neutral,
                icon: SpIcons.ban,
                selected: avoid.contains(option),
                onTap: () {
                  final next = {...avoid};
                  if (!next.remove(option)) next.add(option);
                  unawaited(cubit.setAvoid(next));
                },
              ),
          ],
        ),
        const SizedBox(height: Spacing.xs),
        PrimaryButton(label: 'Done', onTap: () => Navigator.of(context).pop()),
      ],
    );
  }
}

class DeleteAccountSheet extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Spacing.s,
      children: [
        const Paprika(mood: PaprikaMood.oops, size: 96, decorative: true),
        const AppText(
          text: 'Delete your account?',
          config: FontConfigs.h2,
          align: TextAlign.center,
        ),
        const AppText.secondary(
          text:
              'Your recipes, drafts, likes, saves and friends go for good. '
              "This can't be undone.",
          config: FontConfigs.body2,
          align: TextAlign.center,
        ),
        const SizedBox(height: Spacing.xs),
        SecondaryButton(
          label: 'Yes, delete everything',
          dark: true,
          onTap: () => Navigator.of(context).pop(true),
        ),
        SecondaryButton(
          label: 'Keep my account',
          outlined: true,
          onTap: () => Navigator.of(context).pop(false),
        ),
      ],
    );
  }
}

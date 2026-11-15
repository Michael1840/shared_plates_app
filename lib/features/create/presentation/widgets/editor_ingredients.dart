import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/motion.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/utils/formatters.dart';
import 'package:shared_plates_app/core/widgets/motion/pressable.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/features/create/domain/food_matcher.dart';
import 'package:shared_plates_app/features/create/domain/recipe_draft.dart';
import 'package:shared_plates_app/features/create/presentation/bloc/recipe_editor_cubit.dart';
import 'package:shared_plates_app/features/create/presentation/widgets/editor_fields.dart';

class IngredientsCard extends StatelessWidget {
  const IngredientsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RecipeEditorCubit>().state;
    final cubit = context.read<RecipeEditorCubit>();
    final ingredients = state.draft.ingredients;
    final missing = state.showProblems && state.draft.ingredients.isEmpty;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: context.container,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: missing ? context.primary : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ReorderableListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            buildDefaultDragHandles: false,
            onReorderItem: cubit.reorderIngredient,
            proxyDecorator: (child, _, _) => Material(
              color: context.container,
              elevation: 4,
              shadowColor: context.sp.shadow,
              borderRadius: BorderRadius.circular(Rounding.chip),
              child: child,
            ),
            children: [
              for (final (i, ing) in ingredients.indexed)
                IngredientLine(
                  key: ValueKey(ing.id),
                  index: i,
                  ingredient: ing,
                  library: state.library,
                  suggestion: state.suggestionFor(ing),
                ),
            ],
          ),
          const _AddIngredient(),
        ],
      ),
    );
  }
}

class IngredientLine extends StatefulWidget {
  const IngredientLine({
    required this.index,
    required this.ingredient,
    required this.library,
    required this.suggestion,
    super.key,
  });

  final int index;
  final DraftIngredient ingredient;
  final FoodLibrary library;
  final FoodMatch? suggestion;

  @override
  State<IngredientLine> createState() => _IngredientLineState();
}

class _IngredientLineState extends State<IngredientLine> {
  late final TextEditingController _text = TextEditingController(
    text: widget.ingredient.rawText,
  );
  late final TextEditingController _cost = TextEditingController(
    text: _rands(widget.ingredient.costCents),
  );
  final FocusNode _focus = FocusNode();
  bool _editing = false;

  static String _rands(int? cents) {
    if (cents == null) return '';
    final rands = cents / 100;
    return rands == rands.roundToDouble()
        ? '${rands.round()}'
        : rands.toStringAsFixed(2);
  }

  @override
  void initState() {
    super.initState();
    _focus.addListener(() {
      if (!_focus.hasFocus && _editing) _commit();
    });
  }

  @override
  void dispose() {
    _text.dispose();
    _cost.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _commit() {
    setState(() => _editing = false);
    context.read<RecipeEditorCubit>().updateIngredient(
      widget.ingredient.id,
      _text.text,
    );
  }

  void _edit() {
    _text.text = widget.ingredient.rawText;
    setState(() => _editing = true);
    _focus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final ing = widget.ingredient;
    final cubit = context.read<RecipeEditorCubit>();
    return Dismissible(
      key: ValueKey('dismiss-${ing.id}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => cubit.removeIngredient(ing.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: Spacing.m),
        color: context.sp.blush,
        child: SpIcon(SpIcons.trash, color: context.primaryDeep),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: context.sp.progressTrack)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: Spacing.s,
          children: [
            ReorderableDragStartListener(
              index: widget.index,
              child: Semantics(
                label: 'Drag to reorder',
                child: SpIcon(
                  SpIcons.grip,
                  size: 20,
                  strokeWidth: 3,
                  color: context.sp.handle,
                ),
              ).paddingOnly(top: 2),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5,
              children: [
                if (_editing)
                  EditorTextField(
                    controller: _text,
                    focusNode: _focus,
                    config: FontConfigs.body2,
                    semanticLabel: 'Ingredient',
                    maxLines: 3,
                    minLines: 1,
                    textInputAction: TextInputAction.done,
                    capitalization: TextCapitalization.none,
                    inputFormatters: [LengthLimitingTextInputFormatter(200)],
                    onSubmitted: (_) => _focus.unfocus(),
                  )
                else
                  Pressable(
                    isButton: false,
                    onTap: _edit,
                    semanticLabel: 'Edit ${ing.rawText}',
                    child: _IngredientText(ingredient: ing),
                  ),
                _MatchInfo(
                  ingredient: ing,
                  library: widget.library,
                  suggestion: widget.suggestion,
                ),
              ],
            ).expand(),
            _CostField(
              controller: _cost,
              onChanged: (v) => cubit.setCost(ing.id, v),
              label: 'Price of ${ing.displayName} in rand',
            ),
          ],
        ),
      ),
    );
  }
}

class _IngredientText extends StatelessWidget {
  const _IngredientText({required this.ingredient});

  final DraftIngredient ingredient;

  @override
  Widget build(BuildContext context) {
    final amount = ingredient.amountLabel;
    final prep = ingredient.prepNote;
    final rest = [ingredient.displayName, ?prep].join(', ');
    return AppRichText(
      config: FontConfigs.body2,
      spans: [
        if (amount != null)
          TextSpan(
            text: '$amount ',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        TextSpan(text: amount == null ? ingredient.rawText : rest),
      ],
    );
  }
}

class _MatchInfo extends StatelessWidget {
  const _MatchInfo({
    required this.ingredient,
    required this.library,
    required this.suggestion,
  });

  final DraftIngredient ingredient;
  final FoodLibrary library;
  final FoodMatch? suggestion;

  @override
  Widget build(BuildContext context) {
    final food = library.foods[ingredient.foodId];
    if (food != null) {
      final def = ingredient.unit == null
          ? null
          : library.units[ingredient.unit];
      final counted = def == null || def.kind == UnitKind.count;
      final grams = library.gramsFor(
        foodId: food.id,
        quantity: ingredient.quantity,
        unit: ingredient.unit,
        portion: ingredient.portionLabel,
      );
      final q = ingredient.quantity;
      final each = counted && grams != null && q != null ? grams / q : null;
      final detail = each == null ? '' : ' · ~${each.round()} g each';
      return Row(
        spacing: Spacing.xs,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: context.herb,
              shape: BoxShape.circle,
            ),
          ),
          AppText(
            text: '${food.name}$detail',
            config: FontConfigs.sublabel2,
            color: context.sp.success,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ).flexible(),
        ],
      );
    }
    if (ingredient.keptAsIs || library.isEmpty) return const SizedBox.shrink();
    final suggested = suggestion;
    final cubit = context.read<RecipeEditorCubit>();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: context.sp.honeySoft,
        borderRadius: BorderRadius.circular(Rounding.chip),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Spacing.xs,
        children: [
          AppText(
            text:
                "Not in the food library yet. It'll show as written, "
                'without nutrition.',
            config: FontConfigs.sublabel2,
            color: context.sp.honeyInk,
          ),
          Wrap(
            spacing: Spacing.xs,
            runSpacing: Spacing.xs,
            children: [
              if (suggested != null)
                _PillButton(
                  label: 'Use "${suggested.food.name}"',
                  filled: true,
                  onTap: () => cubit.useFood(ingredient.id, suggested.food.id),
                ),
              _PillButton(
                label: 'Keep as is',
                filled: false,
                onTap: () => cubit.keepAsIs(ingredient.id),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.label,
    required this.filled,
    required this.onTap,
  });

  final String label;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: filled ? context.container : Colors.transparent,
          borderRadius: BorderRadius.circular(Rounding.pill),
        ),
        child: Center(
          widthFactor: 1,
          child: Text(
            label,
            style: context
                .textStyle(
                  FontConfigs.sublabel2,
                  color: filled ? context.textPrimary : context.sp.honeyInk,
                  weight: FontWeight.w600,
                )
                .copyWith(decoration: filled ? null : TextDecoration.underline),
          ),
        ),
      ),
    );
  }
}

class _CostField extends StatelessWidget {
  const _CostField({
    required this.controller,
    required this.onChanged,
    required this.label,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: context.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        spacing: 2,
        children: [
          const AppText(
            text: 'R',
            config: FontConfigs.sublabel1,
            weight: FontWeight.w600,
          ),
          EditorTextField(
            controller: controller,
            config: FontConfigs.sublabel1,
            hint: '–',
            semanticLabel: label,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
              LengthLimitingTextInputFormatter(6),
            ],
            onChanged: onChanged,
          ).expand(),
        ],
      ),
    );
  }
}

class _AddIngredient extends StatefulWidget {
  const _AddIngredient();

  @override
  State<_AddIngredient> createState() => _AddIngredientState();
}

class _AddIngredientState extends State<_AddIngredient> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focus = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _submit(String text) {
    if (text.trim().isEmpty) {
      _focus.requestFocus();
      return;
    }
    context.read<RecipeEditorCubit>().addIngredients(text);
    _controller.clear();
    _focus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: Spacing.xxs,
      children: [
        Pressable(
          onTap: () => _submit(_controller.text),
          semanticLabel: 'Add ingredient',
          child: ListenableBuilder(
            listenable: _controller,
            builder: (context, _) {
              final ready = _controller.text.trim().isNotEmpty;
              return AnimatedContainer(
                duration: context.motion(Motion.small),
                width: Sizes.minTap,
                height: Sizes.minTap,
                decoration: BoxDecoration(
                  color: ready ? context.primary : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: SpIcon(
                  SpIcons.plus,
                  size: 20,
                  color: ready ? context.onPrimary : context.primary,
                ),
              );
            },
          ),
        ),
        EditorTextField(
          controller: _controller,
          focusNode: _focus,
          config: FontConfigs.body2,
          hint: 'e.g. 2 cups rice',
          semanticLabel: 'Add an ingredient',
          textInputAction: TextInputAction.next,
          capitalization: TextCapitalization.none,
          inputFormatters: [LengthLimitingTextInputFormatter(200)],
          onSubmitted: _submit,
        ).expand(),
      ],
    ).paddingSymmetric(vertical: 2);
  }
}

class TotalsCard extends StatelessWidget {
  const TotalsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RecipeEditorCubit>().state;
    final cost = state.draft.costCents;
    final perServing = state.draft.costPerServing;
    final kcal = state.nutrition.matched == 0 ? null : state.nutrition.kcal;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: context.textPrimary,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        spacing: Spacing.xs,
        children: [
          _Total(
            label: 'Est. cost',
            value: cost == null ? '–' : Formatters.rands(cost),
          ).expand(),
          _Total(
            label: 'Per serving',
            value: perServing == null ? '–' : Formatters.rands(perServing),
          ).expand(),
          _Total(
            label: 'Energy / serving',
            value: kcal == null ? '–' : '${kcal.round()} kcal',
          ).expand(),
        ],
      ),
    );
  }
}

class _Total extends StatelessWidget {
  const _Total({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 2,
      children: [
        AppText(
          text: label,
          config: FontConfigs.sublabel3,
          color: context.sp.handle,
        ),
        AppText(
          text: value,
          config: FontConfigs.body1,
          weight: FontWeight.w700,
          color: context.background,
        ),
      ],
    );
  }
}

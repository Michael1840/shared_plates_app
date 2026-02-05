import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ui/custom/buttons/wide_text_button.dart';
import '../../../../core/ui/custom/containers/default_container.dart';
import '../../../../core/ui/custom/fields/my_dropdown_field.dart';
import '../../../../core/ui/custom/fields/my_form_field.dart';
import '../../../../core/ui/custom/icons/my_icons.dart';
import '../../../../core/ui/layouts/page_container.dart';
import '../../../../core/utils/extensions.dart';
import '../../../bloc/create_recipe/create_recipe_cubit.dart';
import '../../../bloc/recipe_bloc/recipe_bloc.dart';
import '../../recipe_detail/items/servings_container.dart';

class DetailsPage extends StatelessWidget {
  final CreateRecipeState state;
  final CreateRecipeCubit cubit;
  final TextEditingController titleCont;
  final TextEditingController descriptionCont;
  final void Function() changePage;
  const DetailsPage({
    super.key,
    required this.cubit,
    required this.state,
    required this.titleCont,
    required this.descriptionCont,
    required this.changePage,
  });

  @override
  Widget build(BuildContext context) {
    return PageContainer.scrollable(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (state.imageFile == null)
            DefaultContainer(
              width: double.infinity,
              height: 150,
              child: Icon(
                MyIcons.add_plus,
                size: 30,
                color: context.textSecondary,
              ),
            ).onTap(() {
              cubit.selectImage();
            })
          else
            DefaultContainer(
              padding: EdgeInsets.zero,
              width: double.infinity,
              height: 150,
              child: Image.file(
                state.imageFile!,
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),
            ).onTap(() {
              cubit.selectImage();
            }),

          ServingsContainer(
            serves: state.serves,
            increment: cubit.incrementServes,
            decrement: cubit.decrementServes,
          ),
          Column(
            spacing: 16,
            children: [
              MyDropdownButton(
                title: 'Privacy Status',
                value: '',
                initialValue: state.selectedPrivacyStatus,
                hint: 'Privacy Status',
                onChanged: (s) {
                  cubit.updatePrivacy(s);
                },
                items: const [
                  CustomDropdownValue<String>(id: '1', value: 'Public'),
                  CustomDropdownValue<String>(id: '2', value: 'Friends'),
                  CustomDropdownValue<String>(id: '3', value: 'Private'),
                ],
              ),
              MyFormField(
                hint: 'Your recipe title',
                title: 'Recipe Title',
                // icon: MyIcons.label,
                controller: titleCont,
                onChanged: (s) {
                  cubit.updateTitle(s);
                },
                radius: 20,
              ),
              MyFormField(
                hint: 'Your recipe description',
                title: 'Description',
                controller: descriptionCont,
                onChanged: (s) {
                  cubit.updateDescription(s);
                },
                minLines: 5,
                maxLines: 8,
                radius: 20,
              ),
            ],
          ),

          BlocBuilder<RecipeBloc, RecipeState>(
            builder: (context, recipeState) {
              return WideTextButton(
                text: 'Next',
                onTap: changePage,
                disabled:
                    state.selectedPrivacyStatus == null ||
                    state.title.isNull ||
                    state.description.isNull,
              );
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

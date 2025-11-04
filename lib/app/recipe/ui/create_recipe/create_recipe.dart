import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/theme.dart';
import '../../../core/utils/extensions.dart';
import '../../bloc/create_recipe/create_recipe_cubit.dart';
import '../../bloc/recipe_bloc/recipe_bloc.dart';
import '../../data/models/create_recipe_model.dart';
import 'pages/details_page.dart';
import 'pages/ingredients_page.dart';
import 'pages/instructions_page.dart';
import 'pages/publish_page.dart';

class CreateRecipePage extends StatefulWidget {
  const CreateRecipePage({super.key});

  @override
  State<CreateRecipePage> createState() => CreateRecipePageState();
}

class CreateRecipePageState extends State<CreateRecipePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabCont;

  late final CreateRecipeCubit _cubit;

  final TextEditingController _titleCont = TextEditingController();
  final TextEditingController _descriptionCont = TextEditingController();

  @override
  void initState() {
    super.initState();

    _cubit = context.read<CreateRecipeCubit>();
    _tabCont = TabController(length: 4, vsync: this);
  }

  void _createRecipe(CreateRecipeState state) {
    if (_titleCont.trimmedText.isEmpty ||
        _descriptionCont.trimmedText.isEmpty ||
        state.selectedPrivacyStatus == null) {
      return;
    }

    if (state.ingredients.isEmpty) {
      context.showSnackBarError('You must have at least one ingredient.');
      return;
    }

    if (state.steps.isEmpty) {
      context.showSnackBarError('You must have at least one step.');
      return;
    }

    final CreateRecipeModel req = CreateRecipeModel(
      title: _titleCont.trimmedText,
      description: _descriptionCont.trimmedText,
      serves: state.serves.toString(),
      tags: state.tags,
      privacyStatus: state.selectedPrivacyStatus!.id.toString(),
      ingredients: state.ingredients.map((i) => i.toJson()).toList(),
      steps: state.steps.map((i) => i.toJson()).toList(),
      image: state.imageFile!,
    );

    context.read<RecipeBloc>().add(RecipeCreate(req: req));
  }

  void _goToTab(int index) => _tabCont.animateTo(index);

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateRecipeCubit, CreateRecipeState>(
      listener: (context, state) {
        if (state.isError) {
          context.showSnackBarError(state.loadingResult.error!);
        }
      },
      child: BlocBuilder<CreateRecipeCubit, CreateRecipeState>(
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              toolbarHeight: 40,
              leadingWidth: 6,
              leading: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // MyIconButton(
                  //   icon: MyIcons.chevron_left,
                  //   onTap: () {
                  //     context.pop();
                  //   },
                  // ).paddingLeft(20),
                ],
              ),
              title: const AppText.heading(text: 'Create Recipe', size: 18),
              bottom: TabBar(
                controller: _tabCont,
                isScrollable: true,
                tabAlignment: TabAlignment.center,
                indicatorAnimation: TabIndicatorAnimation.elastic,
                indicatorColor: context.green,
                indicatorPadding: EdgeInsetsGeometry.zero,
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: context.myTextStyle(color: context.green),
                splashFactory: NoSplash.splashFactory,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                tabs: const [
                  Tab(text: 'Details'),
                  Tab(text: 'Ingredients'),
                  Tab(text: 'Instructions'),
                  Tab(text: 'Publish'),
                ],
                unselectedLabelColor: context.textSecondary,
              ),
            ),
            body: Padding(
              padding: EdgeInsets.only(
                bottom:
                    MediaQuery.of(context).viewInsets.bottom >
                        kBottomNavigationBarHeight
                    ? MediaQuery.of(context).viewInsets.bottom -
                          kBottomNavigationBarHeight
                    : MediaQuery.of(context).viewInsets.bottom,
              ),
              child: TabBarView(
                controller: _tabCont,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  DetailsPage(
                    cubit: _cubit,
                    state: state,
                    titleCont: _titleCont,
                    descriptionCont: _descriptionCont,
                    changePage: () {
                      _goToTab(1);
                    },
                  ),
                  IngredientsPage(
                    cubit: _cubit,
                    state: state,
                    changePage: () {
                      _goToTab(2);
                    },
                  ),
                  InstructionsPage(
                    cubit: _cubit,
                    state: state,
                    changePage: () {
                      _goToTab(3);
                    },
                  ),
                  PublishPage(
                    cubit: _cubit,
                    state: state,
                    changePage: () {
                      _createRecipe(state);
                    },
                    canCreate:
                        _titleCont.trimmedText.isNotEmpty &&
                        _descriptionCont.trimmedText.isNotEmpty,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  double _calcContainerHeight(int length) {
    if (length <= 0) {
      return 0;
    }

    int containerHeight = 48 + 8 + 10;

    double paddingHeight = (length - 1) * 10;

    return (containerHeight * length) + paddingHeight;
  }
}

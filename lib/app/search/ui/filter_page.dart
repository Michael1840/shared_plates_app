import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/theme.dart';
import '../../core/ui/custom/buttons/my_icon_button.dart';
import '../../core/ui/custom/fields/search_field.dart';
import '../../core/ui/custom/icons/my_icons.dart';
import '../../core/ui/layouts/page_container.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/extensions.dart';
import '../../recipe/data/repo/recipe_repo.dart';
import '../bloc/search_cubit/search_cubit.dart';
import 'items/smart_slider.dart';
import 'items/switch_row.dart';
import 'items/wrapping_tag_container.dart';

class FilterHomePage extends StatefulWidget {
  final SearchCubit? cubit;
  const FilterHomePage({super.key, this.cubit});

  @override
  State<FilterHomePage> createState() => _FilterHomePageState();
}

class _FilterHomePageState extends State<FilterHomePage> {
  final Debouncer _debouncer = Debouncer();

  final TextEditingController _searchCont = TextEditingController();

  late SearchCubit _cubit;

  @override
  void initState() {
    super.initState();

    _initCubit();
  }

  void _initCubit() {
    _cubit = widget.cubit ?? SearchCubit(context.read<RecipesRepository>());

    _searchCont.text = _cubit.state.searchFilter ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          return PageContainer(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.refresh_rounded,
                      color: context.primary,
                      size: 14,
                    ),
                    AppText.heading(
                      text: ' Reset All',
                      size: 12,
                      color: context.primary,
                    ),
                  ],
                ).onTap(() {
                  _cubit.reset();
                }),
                Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: SearchField(
                        hint: 'Search recipes',
                        controller: _searchCont,
                        onChanged: (s) {
                          _debouncer.debounce(
                            duration: const Duration(milliseconds: 250),
                            onDebounce: () =>
                                context.read<SearchCubit>().searchFilter(s),
                          );
                        },
                      ),
                    ),
                    MyIconButton.colored(
                      icon: MyIcons.chevron_right,
                      padding: 14,
                      color: context.green,
                      // disabled: !state.isEnabled,
                      onTap: () {
                        final searchCubit = context.read<SearchCubit>();
                        context.pop();

                        Future.delayed(const Duration(milliseconds: 50)).then((
                          value,
                        ) {
                          if (!context.mounted) return;
                          searchCubit.search();
                          context.goNamed(Routes.search, extra: searchCubit);
                        });
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 32,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 8,
                          children: [
                            SwitchRow(
                              title: 'Friends only',
                              onChanged: (b) {
                                _cubit.updateFriendsOnly(b);
                              },
                              value: state.friendsOnly ?? false,
                            ),
                            SwitchRow(
                              title: 'Match all tags',
                              onChanged: (b) {
                                _cubit.updateMatchAllTags(b);
                              },
                              value: state.matchAllTags ?? false,
                            ),
                            SwitchRow(
                              title: 'Only liked recipes',
                              onChanged: (b) {
                                _cubit.updateLikedOnly(b);
                              },
                              value: state.likedOnly ?? false,
                            ),
                          ],
                        ),

                        WrappingTagContainer(
                          title: 'Filter',
                          tags: kFilters,
                          cubit: _cubit,
                          isFilter: true,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 8,
                          children: [
                            const AppText.primary(text: 'Max Price', size: 16),
                            SmartPriceSlider(
                              maxPrice: 3000,
                              step: 10,
                              sliderValue: state.maxPrice.toDouble(),
                              onChanged: (value, maxPrice) {
                                _cubit.updateMaxPrice(value, maxPrice);
                              },
                            ),
                          ],
                        ),

                        WrappingTagContainer(
                          title: 'Category',
                          tags: kCategories,
                          cubit: _cubit,
                        ),
                        WrappingTagContainer(
                          title: 'Diet',
                          tags: kDiets,
                          cubit: _cubit,
                        ),
                        WrappingTagContainer(
                          title: 'Cuisine',
                          tags: kCuisines,
                          cubit: _cubit,
                        ),
                      ],
                    ),
                  ),
                ),

                // const WideTextButton(
                //   text: 'Explore',
                //   // onTap: create,
                //   // disabled: !canCreate || !state.canCreate,
                //   // isLoading: recipeState.isUserLoading,
                // ),
              ],
            ),
          );
        },
      ),
    );
  }
}

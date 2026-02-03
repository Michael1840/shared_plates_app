import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import '../../../core/ui/custom/containers/tag_container.dart';
import '../../bloc/search_cubit/search_cubit.dart';

class WrappingTagContainer extends StatelessWidget {
  final String title;
  final List<String> tags;
  final SearchCubit cubit;
  final bool isFilter;
  const WrappingTagContainer({
    super.key,
    required this.title,
    required this.tags,
    required this.cubit,
    this.isFilter = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        AppText.primary(text: title, size: 16),
        Wrap(
          direction: Axis.horizontal,
          runSpacing: 12,
          spacing: 12,
          alignment: WrapAlignment.start,
          children: [
            for (final tag in tags)
              TagContainer(
                title: tag,
                isActive: isFilter
                    ? cubit.state.popularityFilter == tag.toLowerCase()
                    : cubit.state.tags.contains(tag),
                onTap: isFilter
                    ? () {
                        cubit.updatePopularityFilter(tag.toLowerCase());
                      }
                    : () {
                        cubit.toggleTag(tag);
                      },
              ),
          ],
        ),
      ],
    );
  }
}

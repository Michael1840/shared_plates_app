import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/theme/theme.dart';
import '../../../core/ui/custom/animations/animate_list.dart';
import '../../../core/ui/custom/buttons/my_icon_button.dart';
import '../../../core/ui/custom/icons/my_icons.dart';
import '../../../core/ui/layouts/page_container.dart';
import '../../../core/utils/extensions.dart';
import '../../../recipe/data/models/recipe_model.dart';
import '../../../recipe/data/models/tag_model.dart';
import 'items/menu_item.dart';

class MenuPlanner extends StatefulWidget {
  const MenuPlanner({super.key});

  @override
  State<MenuPlanner> createState() => _MenuPlannerState();
}

class _MenuPlannerState extends State<MenuPlanner> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 40,
        leadingWidth: double.infinity,
        centerTitle: false,
        leading: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 20),
                MyIconButton(
                  icon: MyIcons.chevron_left,
                  onTap: () {
                    context.pop();
                  },
                ),
                const SizedBox(width: 20),
                const AppText.heading(text: 'Menu Planner', size: 14),
              ],
            ),
          ],
        ),
      ),
      body: PageContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            TableCalendar(
              // Config
              availableCalendarFormats: const {
                CalendarFormat.week: 'Weekly',
                CalendarFormat.month: 'Monthly',
              },
              calendarFormat: _calendarFormat,
              firstDay: DateTime.now().subtract(const Duration(days: 365)),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              focusedDay: _focusedDay,

              // Methods
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },

              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },

              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                });
              },

              // Styles
              headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonVisible: true, // Hiding button for cleaner look
                titleTextStyle: context.myTextStyle(
                  size: 16,
                  weight: Weights.bold,
                  color: context.textPrimary,
                ),
                formatButtonDecoration: BoxDecoration(
                  color: context.container, // Your theme container color
                  border: Border.all(
                    color: context.borderPrimary,
                  ), // Your theme border
                  borderRadius: BorderRadius.circular(20),
                ),
                formatButtonPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                formatButtonTextStyle: context.myTextStyle(
                  size: 12,
                  weight: Weights.medium,
                  color: context.textPrimary,
                ),
                leftChevronIcon: Icon(
                  MyIcons.arrow_left_md, // Assuming you have an arrow icon
                  color: context.textSecondary,
                  size: 24,
                ),
                rightChevronIcon: Icon(
                  MyIcons.arrow_right_md,
                  color: context.textSecondary,
                  size: 24,
                ),
                headerPadding: const EdgeInsets.symmetric(vertical: 8),
              ),

              // Method Styles
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: context.myTextStyle(
                  color: context.textSecondary,
                  size: 12,
                  weight: Weights.medium,
                ),
                weekendStyle: context.myTextStyle(
                  color: context
                      .textSecondary, // Keeping uniform or maybe slightly dimmer
                  size: 12,
                  weight: Weights.medium,
                ),
              ),

              // Method Styles
              calendarStyle: CalendarStyle(
                // TODAY
                todayDecoration: BoxDecoration(
                  color: context.primary.withValues(
                    alpha: 0.15,
                  ), // Subtle highlight for today
                  shape: BoxShape.circle,
                ),
                todayTextStyle: context.myTextStyle(
                  color: context.primary,
                  weight: Weights.bold,
                ),

                // SELECTED DAY
                selectedDecoration: BoxDecoration(
                  color: context.green, // Using your custom green accent
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: context.green.withValues(alpha: 0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                selectedTextStyle: context.myTextStyle(
                  color: context.white,
                  weight: Weights.bold,
                ),

                // DEFAULT DAYS
                defaultTextStyle: context.myTextStyle(
                  color: context.textPrimary,
                  weight: Weights.reg,
                ),

                // WEEKEND DAYS
                weekendTextStyle: context.myTextStyle(
                  color:
                      context.textSecondary, // Differentiate weekends slightly
                  weight: Weights.reg,
                ),

                // OUTSIDE DAYS (Previous/Next month days)
                outsideTextStyle: context.myTextStyle(
                  color: context.textSecondary.withValues(alpha: 0.5),
                ),
              ),
            ),
            AppText.heading(text: 'Today\'s Meals', size: 16),
            Expanded(
              child: MySliverList(
                itemBuilder: (context, index) => MenuItem(
                  recipe: RecipeModel(
                    id: 1,
                    title: 'Title',
                    cost: 2,
                    serves: 3,
                    createdBy: '',
                    isLiked: false,
                    tagGroup: TagGroup(count: 0, tags: []),
                    trendingScore: 0,
                    likesThisWeek: 0,
                    viewsThisWeek: 0,
                    likeCount: 0,
                  ),
                ),
                itemCount: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

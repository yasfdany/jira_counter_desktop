import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jira_counter/ui/screens/home/components/task_list.dart';
import 'package:jira_counter/utils/extensions.dart';
import 'package:widget_helper/widget_helper.dart';

import '../../../config/themes.dart';
import '../../../data/model/story_point_data.dart';
import '../../../main.dart';
import '../../components/buttons/primary_button.dart';
import '../../components/buttons/ripple_button.dart';
import 'components/filter_modal.dart';
import 'components/filter_panel.dart';
import 'components/item_total_story_point.dart';
import 'components/loading_and_empty_widget.dart';
import 'components/top_panel.dart';
import 'provider/task_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static String get routeName => '/home';
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(taskProvider).loadData();
  }

  @override
  Widget build(BuildContext context) {
    widthScreen = MediaQuery.of(context).size.width;
    heightScreen = MediaQuery.of(context).size.height;

    final selectedAccountId = ref.watch(taskProvider).selectedAccountId;
    final loading = ref.watch(taskProvider).loading;
    final issues = ref.watch(taskProvider).totalStoryPoint;
    final isWideScreen = context.isWideScreen;

    issues.sort((a, b) => b.point.compareTo(a.point));

    return Scaffold(
      body: Row(
        children: [
          if (isWideScreen) const FilterPanel(),
          Column(
            children: [
              const TopPanel(),
              Row(
                children: [
                  issues.isEmpty
                      ? LoadingAndEmptyWidget(
                          loading: loading,
                        ).addExpanded
                      : ListView.builder(
                          padding: const EdgeInsets.all(18),
                          itemCount: issues.length,
                          itemBuilder: (context, index) {
                            StroyPointData stroyPointData = issues[index];

                            return ItemTotalStoryPoint(
                              stroyPointData: stroyPointData,
                            ).addAllMargin(6);
                          },
                        ).addExpanded,
                  if (isWideScreen && selectedAccountId.isNotNull)
                    const TaskList(),
                ],
              ).addExpanded,
              if (!isWideScreen)
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Themes.stroke,
                ),
              if (!isWideScreen)
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      RippleButton(
                        border: Border.all(color: Themes.stroke),
                        color: Colors.white,
                        onTap: !loading
                            ? () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  builder: ((context) => const FilterModal()),
                                );
                              }
                            : null,
                        text: "Filter",
                        textColor: Themes.black,
                      ).addExpanded,
                      Container(width: 12),
                      PrimaryButton(
                        enable: !loading,
                        onTap: () {
                          ref.read(taskProvider).getIssues(reset: true);
                        },
                        text: loading ? null : "Reload Data",
                        child: loading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation(Themes.primary),
                                ),
                              )
                            : null,
                      ).addExpanded,
                    ],
                  ),
                ),
            ],
          ).addExpanded,
        ],
      ),
    );
  }
}

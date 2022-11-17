import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jira_counter/utils/extensions.dart';
import 'package:widget_helper/widget_helper.dart';

import '../../../../config/themes.dart';
import '../../../components/buttons/primary_button.dart';
import '../../../components/buttons/ripple_button.dart';
import '../../../components/commons/flat_card.dart';
import '../provider/task_provider.dart';

class FilterModal extends ConsumerWidget {
  const FilterModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedStatus = ref.watch(taskProvider).selectedStatus;
    final statuses = ref.watch(taskProvider).statuses;

    return Column(
      children: [
        Container(
          color: Colors.transparent,
          width: double.infinity,
          height: 30.hp,
        ).onTap(() {
          Navigator.pop(context);
        }),
        Container(
          margin: const EdgeInsets.only(
            left: 18,
            right: 18,
          ),
          child: FlatCard(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    FlatCard(
                      width: 80,
                      height: 5,
                      color: Themes.stroke,
                    ),
                  ],
                ).addAllMargin(24),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Themes.stroke,
                ),
                ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: statuses.length,
                  itemBuilder: (context, index) {
                    return RippleButton(
                      padding: const EdgeInsets.all(14),
                      color: Themes.white,
                      border: Border.all(
                        color: selectedStatus.contains(statuses[index])
                            ? Themes.primary
                            : Themes.stroke,
                        width: 1,
                      ),
                      onTap: () {
                        ref.read(taskProvider).addStatusFilter(statuses[index]);
                      },
                      textColor: Themes.black,
                      child: Row(
                        children: [
                          Text(
                            statuses[index],
                            style: Themes().black14,
                          ).addFlexible,
                        ],
                      ),
                    ).addMarginBottom(12);
                  },
                ).addExpanded,
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Themes.stroke,
                ),
                Row(
                  children: [
                    RippleButton(
                      border: Border.all(color: Themes.stroke),
                      onTap: () {
                        Navigator.pop(context);
                      },
                      text: "Cancel",
                      textColor: Themes.black,
                    ).addExpanded,
                    Container(width: 12),
                    PrimaryButton(
                      onTap: () {
                        ref.read(taskProvider).getIssues(reset: true);
                        Navigator.pop(context);
                      },
                      text: "Apply Filter",
                    ).addExpanded,
                  ],
                ).addAllMargin(24)
              ],
            ),
          ),
        ).addExpanded,
      ],
    );
  }
}

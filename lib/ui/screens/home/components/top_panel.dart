import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jira_counter/ui/screens/login/login_screen.dart';
import 'package:jira_counter/utils/extensions.dart';
import 'package:widget_helper/widget_helper.dart';

import '../../../../config/themes.dart';
import '../../../../router/router.dart';
import '../../../components/buttons/primary_button.dart';
import '../../../components/buttons/ripple_button.dart';
import '../../../components/commons/flat_card.dart';
import '../../../components/dialogs/question_dialog.dart';
import '../../login/provider/auth_provider.dart';
import '../provider/project_provider.dart';
import '../provider/task_provider.dart';
import 'project_selector_dialog.dart';

class TopPanel extends ConsumerWidget {
  const TopPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final project = ref.watch(projectProvider).selectedProject;
    final loading = ref.watch(taskProvider).loading;
    final onlySubtask = ref.watch(taskProvider).onlySubtask;
    final isWideScreen = context.isWideScreen;

    return Column(
      children: [
        FlatCard(
          borderRadius: BorderRadius.zero,
          width: double.infinity,
          height: Platform.isAndroid || Platform.isIOS ? 105 : 81,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (Platform.isAndroid || Platform.isIOS)
                Container(
                  height: 24,
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!isWideScreen)
                    RippleButton(
                      borderRadius: BorderRadius.zero,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      onTap: !loading
                          ? () {
                              showDialog(
                                context: context,
                                builder: ((context) =>
                                    const ProjectSelectorDialog()),
                              );
                            }
                          : null,
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 40.wp,
                                child: Text(
                                  project?.name ?? "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Themes().blackBold16,
                                ),
                              ),
                              Text(
                                project?.projectTypeKey ?? "",
                                style: Themes().black14,
                              ),
                            ],
                          ).addMarginRight(24),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 24,
                          ),
                        ],
                      ),
                    )
                  else
                    Expanded(child: Container()),
                  if (isWideScreen)
                    PopupMenuButton<int>(
                      icon: const Icon(Icons.settings),
                      onSelected: (int selected) {
                        switch (selected) {
                          case 0:
                            ref.read(taskProvider).toggleOnlySubtask();
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<int>>[
                        PopupMenuItem<int>(
                          value: 0,
                          child: Row(
                            children: [
                              Icon(
                                onlySubtask
                                    ? Icons.check_box_rounded
                                    : Icons.check_box_outline_blank_rounded,
                              ).addMarginRight(6),
                              Text(
                                'Count only Subtask',
                                style: Themes().black12,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ).addMarginRight(6),
                  // RippleButton(
                  //   padding: const EdgeInsets.all(8),
                  //   onTap: () {},
                  //   child: const Icon(Icons.settings),
                  // ).addMarginRight(12),
                  if (isWideScreen)
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
                    ).addSymmetricMargin(
                      vertical: 18,
                    ),
                  RippleButton(
                    border: Border.all(color: Themes.stroke),
                    onTap: !loading
                        ? () {
                            showDialog(
                              context: context,
                              builder: (context) => QuestionDialog(
                                title: "Logout",
                                message: "Are you sure want to logoug now?",
                                negativeAction: true,
                                positiveText: "Logout",
                                negativeText: "Cancel",
                                onConfirm: () async {
                                  await ref.read(authProvider).logout();
                                  router.replace(LoginScreen.routeName);
                                },
                                onCancel: () {
                                  Navigator.pop(context);
                                },
                              ),
                            );
                          }
                        : null,
                    text: "Logout",
                    textColor: Themes.red,
                  ).addMarginOnly(
                    left: 12,
                    right: 24,
                    top: 18,
                    bottom: 18,
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          height: 1,
          color: Themes.stroke,
        ),
      ],
    );
  }
}

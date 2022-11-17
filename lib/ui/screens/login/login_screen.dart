import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jira_counter/main.dart';
import 'package:jira_counter/ui/screens/home/home_screen.dart';
import 'package:jira_counter/ui/screens/home/provider/task_provider.dart';
import 'package:jira_counter/utils/extensions.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:widget_helper/widget_helper.dart';

import '../../../config/themes.dart';
import '../../../router/router.dart';
import '../../../utils/string_helper.dart';
import '../../components/buttons/primary_button.dart';
import '../../components/commons/flat_card.dart';
import '../../components/commons/safe_statusbar.dart';
import '../../components/textareas/password_textarea.dart';
import '../../components/textareas/textarea.dart';
import 'provider/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  static String get routeName => '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    widthScreen = MediaQuery.of(context).size.width;
    heightScreen = MediaQuery.of(context).size.height;

    return SafeStatusBar(
      statusBarColor: Colors.white,
      child: Consumer(
        builder: (context, ref, _) {
          final router = ref.watch(routerProvider);
          final loading = ref.watch(authProvider).loading;

          return Scaffold(
            backgroundColor: Themes.whiteBg,
            body: Column(
              children: [
                Expanded(
                  child: Center(
                    child: SizedBox(
                      width: context.isWideScreen ? 500 : widthScreen,
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlatCard(
                              border: Border.all(
                                color: Themes.stroke,
                              ),
                              child: Row(
                                children: [
                                  TextArea(
                                    border:
                                        Border.all(color: Colors.transparent),
                                    inputType: TextInputType.url,
                                    controller:
                                        ref.read(authProvider).urlController,
                                    hint: "Enter your jira sub domain",
                                  ).addExpanded,
                                  Text(
                                    ".atlassian.net",
                                    style: Themes().black14,
                                  ).addMarginRight(14)
                                ],
                              ),
                            ),
                            TextArea(
                              inputType: TextInputType.emailAddress,
                              controller:
                                  ref.read(authProvider).emailController,
                              hint: "Enter your jira email",
                            ).addMarginTop(14),
                            PasswordTextarea(
                              controller:
                                  ref.read(authProvider).tokenController,
                              hint: "Enter your jira token",
                            ).addMarginTop(14),
                            Text(
                              "Where to find my token?",
                              style: Themes().primaryBold14,
                            ).addSymmetricMargin(vertical: 12).onTap(() {
                              launchUrlString(
                                "https://support.atlassian.com/atlassian-account/docs/manage-api-tokens-for-your-atlassian-account/",
                                mode: LaunchMode.externalApplication,
                              );
                            }),
                            MultiValueListenableBuilder(
                              valueListenables: [
                                ref.read(authProvider).urlController,
                                ref.read(authProvider).emailController,
                                ref.read(authProvider).tokenController
                              ],
                              builder: (context, values, _) {
                                final bool isSubDomain = ref
                                    .read(authProvider)
                                    .urlController
                                    .text
                                    .isNotEmpty;
                                final bool isValieEmail = ref
                                    .read(authProvider)
                                    .emailController
                                    .text
                                    .isValidEmail;
                                final bool isTokenValid = ref
                                        .read(authProvider)
                                        .tokenController
                                        .text
                                        .length ==
                                    24;

                                return PrimaryButton(
                                  enable: isSubDomain &&
                                      isValieEmail &&
                                      isTokenValid &&
                                      !loading,
                                  onTap: () async {
                                    await ref
                                        .read(authProvider)
                                        .saveCredential();
                                    ref.read(taskProvider).reset();
                                    router.replace(HomeScreen.routeName);
                                  },
                                  text: loading ? null : "Login",
                                  child: loading
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation(
                                                Themes.primary),
                                          ),
                                        )
                                      : null,
                                ).addMarginTop(12);
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  "Created by StudioCloud",
                  style: Themes().primaryBold14,
                ).addMarginBottom(12).onTap(() {
                  launchUrlString(
                    "https://studiocloud.dev",
                    mode: LaunchMode.externalApplication,
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}

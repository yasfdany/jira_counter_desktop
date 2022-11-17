import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:widget_helper/widget_helper.dart';

import '../../../../config/themes.dart';
import '../../../components/buttons/ripple_button.dart';
import '../../../components/commons/flat_card.dart';
import '../../login/provider/auth_provider.dart';

class ItemTask extends ConsumerWidget {
  const ItemTask({
    Key? key,
    required this.issue,
  }) : super(key: key);

  final Map<String, dynamic> issue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RippleButton(
      onTap: () {
        final baseUrl = ref.read(authProvider).baseUrl;
        launchUrlString(
          "$baseUrl/browse/${issue["key"]}",
          mode: LaunchMode.externalApplication,
        );
      },
      border: Border.all(color: Themes.stroke),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${issue["fields"]?["summary"]}",
              style: Themes().blackBold14,
            ),
            Row(
              children: [
                Text(
                  "${issue["key"]}",
                  style: Themes().black12,
                ).addExpanded,
                FlatCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  color: Themes.stroke,
                  child: Text(
                    "${issue["fields"]?["customfield_10016"] ?? 0}",
                    style: Themes().black12,
                  ),
                ),
                SvgPicture.network(
                  "${issue["fields"]?["priority"]?["iconUrl"]}",
                  width: 14,
                ).addMarginLeft(12),
              ],
            ).addMarginTop(12),
          ],
        ),
      ),
    );
  }
}

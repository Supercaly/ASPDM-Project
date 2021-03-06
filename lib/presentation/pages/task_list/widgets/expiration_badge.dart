import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:tasky/presentation/generated/gen_colors.g.dart';

/// Widget displaying a colored badge with
/// the task's expiration [date].
/// If the task is expired the badge is colored
/// red, if it's about to expire in 2 days it's
/// colored yellow, otherwise it's transparent.
class ExpirationBadge extends StatelessWidget {
  /// Task's expiring date.
  final DateTime date;

  ExpirationBadge({
    Key key,
    @required this.date,
  })  : assert(date != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    Color color;
    Color bgColor;

    if (date.toUtc().isBefore(now)) {
      // The task has expired
      color = Colors.white;
      bgColor = EasyColors.timeExpired;
    } else if (date.isBefore(now.add(Duration(days: 2)))) {
      // The task is about to expire in 2 days
      color = Colors.white;
      bgColor = EasyColors.timeExpiring;
    } else {
      // The task is not expired yet
      color = Theme.of(context).textTheme.caption.color;
    }

    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            FeatherIcons.clock,
            color: color,
          ),
          SizedBox(width: 4.0),
          Text(
            DateFormat("dd MMM y").format(date),
            style: Theme.of(context).textTheme.caption.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

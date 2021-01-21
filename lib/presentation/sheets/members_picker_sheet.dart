import 'package:aspdm_project/application/bloc/members_bloc.dart';
import 'package:aspdm_project/domain/entities/user.dart';
import 'package:aspdm_project/domain/repositories/members_repository.dart';
import 'package:aspdm_project/presentation/widgets/members_picker_item_widget.dart';
import 'package:aspdm_project/presentation/widgets/sheet_notch.dart';
import 'package:flutter/material.dart';
import 'package:aspdm_project/services/navigation_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../locator.dart';

/// Display a bottom sheet that picks the members.
/// Passing an existing [List] of [members] to mark them as already selected.
/// Returns a [List] of all the selected [User]s.
Future<List<User>> showMembersPickerSheet(
    BuildContext context, List<User> members) {
  return showModalBottomSheet(
    context: context,
    builder: (context) => MembersPickerSheet(members: members),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
    ),
  );
}

/// Widget that display a bottom sheet that picks members
class MembersPickerSheet extends StatefulWidget {
  final List<User> members;

  MembersPickerSheet({Key key, this.members}) : super(key: key);

  @override
  _MembersPickerSheetState createState() => _MembersPickerSheetState();
}

class _MembersPickerSheetState extends State<MembersPickerSheet> {
  Set<User> _selected;

  @override
  void initState() {
    super.initState();

    if (widget.members != null && widget.members.isNotEmpty)
      _selected = Set<User>.from(widget.members);
    else
      _selected = Set<User>.identity();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 16.0,
        bottom: 24.0,
      ),
      child: BlocProvider<MembersBloc>(
        create: (context) => MembersBloc(locator<MembersRepository>())..fetch(),
        child: BlocBuilder<MembersBloc, MembersState>(
          builder: (context, state) {
            Widget contentWidget;

            if (state.isLoading)
              contentWidget = Center(child: CircularProgressIndicator());
            else if (state.hasError)
              contentWidget = Center(child: Text("No Label to display!"));
            else
              contentWidget = CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate(
                      state.members
                          .map((e) => MembersPickerItemWidget(
                                member: e,
                                selected: _selected.contains(e),
                                onSelected: (selected) => setState(() {
                                  if (selected)
                                    _selected.add(e);
                                  else
                                    _selected.remove(e);
                                }),
                              ))
                          .toList(),
                    ),
                  )
                ],
              );

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SheetNotch(),
                SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Select Members",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      FlatButton(
                        onPressed: () {
                          locator<NavigationService>().pop(
                            result: _selected.toList(growable: false),
                          );
                        },
                        child: Text("Done"),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4.0),
                Expanded(child: contentWidget),
              ],
            );
          },
        ),
      ),
    );
  }
}
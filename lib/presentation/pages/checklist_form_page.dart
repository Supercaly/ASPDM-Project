import 'package:aspdm_project/application/bloc/checklist_form_bloc.dart';
import 'package:aspdm_project/locator.dart';
import 'package:aspdm_project/presentation/misc/checklist_primitive.dart';
import 'package:aspdm_project/presentation/widgets/checklist_form_item_widget.dart';
import 'package:aspdm_project/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

/// Widget that displays a page that lets the user create or edit a given
/// [ChecklistPrimitive].
/// This page will be pushed with a MaterialPageRoot by the parent and not
/// by a normal named route like the other pages. This is done to reduce
/// the named routes since this page is only the mobile version of this screen.
///
/// see:
///   * [showChecklistFormDialog]
class ChecklistFormPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final ChecklistPrimitive primitive;

  ChecklistFormPage({Key key, this.primitive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChecklistFormBloc>(
      create: (context) => ChecklistFormBloc(initialValue: primitive),
      child: BlocListener<ChecklistFormBloc, ChecklistFormState>(
        listenWhen: (_, c) => c.isSave,
        listener: (context, state) => locator<NavigationService>().pop(
          result: ChecklistPrimitive(title: state.title, items: state.items),
        ),
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
            title: SizedBox.shrink(),
            actions: [
              Builder(
                builder: (context) => TextButton(
                  child: Text("Done"),
                  onPressed: () {
                    if (_formKey.currentState.validate())
                      context.read<ChecklistFormBloc>().save();
                  },
                ),
              ),
            ],
            backgroundColor: Colors.white,
            iconTheme:
                Theme.of(context).iconTheme.copyWith(color: Colors.black),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(FeatherIcons.checkCircle),
                      SizedBox(width: 16.0),
                      Expanded(child: ChecklistFormTitleWidget()),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  BlocBuilder<ChecklistFormBloc, ChecklistFormState>(
                    buildWhen: (p, c) => p.items.length != c.items.length,
                    builder: (context, state) => Column(
                      children: state.items
                          .mapIndexed((idx, e) => ChecklistFormItem(
                                key: ValueKey(e),
                                item: e,
                                index: idx,
                              ))
                          .toList(),
                    ),
                  ),
                  ChecklistFormNewItemWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension IterableX<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(int index, E element) f) sync* {
    for (int i = 0; i < this.length; i++) yield f(i, this.elementAt(i));
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'custom_back_button.dart';
import 'custom_drawer.dart';

class ConstrainedScaffold extends StatelessWidget {
  final String? title;
  final Widget body;
  final bool hasBack;

  const ConstrainedScaffold(
      {super.key, this.title, required this.body, this.hasBack = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
              Text(title ?? "ዜማ ያሬድ", style: context.theme.textTheme.bodyLarge),
          centerTitle: true,
          leading: hasBack ? const CustomBackButton() : null),
      drawer: const CustomDrawer(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 600,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: body,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
import 'package:dibbs_flutter_cli/src/utils/object_generate.dart';

String widgetGenerator(ObjectGenerate obj) => '''
import 'package:flutter/material.dart';
class ${obj.name}Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("textFinder"),
    );
  }
}
  ''';

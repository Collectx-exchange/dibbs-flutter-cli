
import 'package:dibbs_flutter_cli/src/utils/object_generate.dart';

String widgetTestGenerator(ObjectGenerate obj) {
  var package = r"import 'package:flutter_modular_test/flutter_modular_test.dart'";

  return '''
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
$package;

import 'package:${obj.packageName}/${obj.import?.replaceFirst("lib/", "").replaceAll("\\", "/")}';

main() {
//  testWidgets('${obj.name}Widget has message', (WidgetTester tester) async {
//    await tester.pumpWidget(buildTestableWidget(${obj.name}Widget()));
//    final textFinder = find.text('${obj.name}');
//    expect(textFinder, findsOneWidget);
//  });
}
  ''';
}

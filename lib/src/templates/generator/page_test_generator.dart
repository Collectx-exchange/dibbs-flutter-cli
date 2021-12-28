import 'package:dibbs_flutter_cli/src/utils/object_generate.dart';

String pageTestGenerator(ObjectGenerate obj) {
  return '''
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  testWidgets('${obj.name}Page has title', (WidgetTester tester) async {
  //  await tester.pumpWidget(buildTestableWidget(${obj.name}Page(title: '${obj.name}')));
  //  final titleFinder = find.text('${obj.name}');
  //  expect(titleFinder, findsOneWidget);
  });
}
  ''';
}

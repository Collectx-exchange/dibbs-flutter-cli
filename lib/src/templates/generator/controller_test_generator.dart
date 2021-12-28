import 'package:dibbs_flutter_cli/src/utils/object_generate.dart';

String getXControllerTestGenerator(ObjectGenerate obj) => "";
/*'''
import 'package:flutter_test/flutter_test.dart';

import 'package:${('${obj.packageName}/${obj.import.replaceFirst("lib/", "").replaceAll("\\", "/")}').replaceFirst('${obj.packageName}/${obj.packageName}', obj.packageName)}';

void main() {

 // ${obj.name}${obj.type[0].toUpperCase()}${obj.type.substring(1)} ${obj.name.toLowerCase()};
 // 
  setUp(() {
 //     ${obj.name.toLowerCase()} = ${obj.module}.to.get<${obj.name}${obj.type[0].toUpperCase()}${obj.type.substring(1)}>();
  });

  group('${obj.name}${obj.type[0].toUpperCase()}${obj.type.substring(1)} Test', () {
 //   test("First Test", () {
 //     expect(${obj.name.toLowerCase()}, isInstanceOf<${obj.name}${obj.type[0].toUpperCase()}${obj.type.substring(1)}>());
 //   });

 //   test("Set Value", () {
 //     expect(${obj.name.toLowerCase()}.value, equals(0));
 //     ${obj.name.toLowerCase()}.increment();
 //     expect(${obj.name.toLowerCase()}.value, equals(1));
 //   });
  });

}
  ''';*/
